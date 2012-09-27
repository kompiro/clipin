module Api
  module V1
    class ClipsController < ApplicationController
      respond_to :json
      skip_before_filter :verify_authenticity_token # allow CSRF
      doorkeeper_for :all

      def index
        tag_id = params[:tag_id]
        if tag_id.present?
          @tag = Tag.find(tag_id)
          @clips = @tag.clips
          @title = @tag.name
        else
          @title = 'All'
          page_num = params[:page]
          if page_num.present?
            @clips = Clip.page page_num
          else
            @clips = Clip.page
          end
        end
        render json: @clips
      end

      def show
        @clip = Clip.find(params[:id])

        render json: @clip.to_json(:include => {:tags => { :except => [:created_at, :updated_at]}})
      end

      def create
        @clip = Clip.find_by_user_id_and_url current_user.id,params[:clip][:url]
        unless @clip.nil?
          @clip.clip_count = @clip.clip_count + 1
          respond_to do |format|
            if @clip.save
              format.json { render json: @clip, status: :ok, location: @clip }
            else
              format.json { render json: @clip.errors, status: :unprocessable_entity }
            end
          end
          return
        end
        @clip = Clip.new(params[:clip])

        if @clip.load and @clip.save
          @clip.tagging
          render json: @clip, status: :created, location: @clip
        else
          render json: @clip.errors, status: :unprocessable_entity
        end
      end

      def update
        @clip = Clip.find(params[:id])
        params[:clip][:tags] = load_tags(params)

        if @clip.update_attributes(params[:clip])
          render json: @clip, status: :ok, location: @clip
        else
          render json: @clip.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @clip = Clip.find(params[:id])
        @clip.destroy
        render json: @clip, status: :ok, location: @clip
      end

      private

      def load_tags(params)
        loaded_tags = []
        return loaded_tags if params[:clip][:tags].nil?
        params[:clip][:tags].each do |tag|
          loaded_tags << Tag.find(tag[:id])
        end
        loaded_tags
      end

      def current_user
        if doorkeeper_token
          @current_user ||= User.find(doorkeeper_token.resource_owner_id)
        end
      end
    end
  end
end
