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
            @clips = @current_user.clips.page(page_num)
          else
            @clips = @current_user.clips.page
          end
        end
        render json: @clips
      end

      def show
        @clip = Clip.find(params[:id])

        render json: @clip.to_json(:include => {:tags => { :except => [:created_at, :updated_at]}})
      end

      def create
        url_info = UrlInfo.where(url: params[:clip][:url]).first
        unless url_info.nil?
          @clip = Clip.where(url_info_id: url_info.id, user_id: @current_user.id).first
          unless @clip.nil?
            @clip.clip_count = @clip.clip_count + 1
            if @clip.save
              render json: @clip, status: :ok, location: @clip
            else
              render json: @clip.errors, status: :unprocessable_entity
            end
            return
          end
        end
        @clip = Clip.new(params[:clip])
        @clip.user = @current_user

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

        if @clip.update(params.require(:clip).permit(:url,:user_id))
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
      def authenticate!
        unless current_user.present?
          respond_to do |format|
            format.json { render :text => "Unauthorized", :status => :unauthorized }
          end
        end
      end
    end
  end
end
