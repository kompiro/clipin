class Api::V1::ClipsController < ApplicationController
  respond_to :json
  before_filter :oauth_authenticate!
  skip_before_filter :verify_authenticity_token # allow CSRF

  def oauth_authenticate!
    token = OAuth2::Provider.access_token(nil, [], env)
    render json: {:error => 'OAuth Authentication Error'}.to_json(),status: :unauthorized unless token.valid?
  end

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
      head :no_content
    else
      render json: @clip.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @clip = Clip.find(params[:id])
    @clip.destroy

    head :no_content
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
end
