class ClipsController < ApplicationController
  # GET /clips
  # GET /clips.json
  def index
    tag = params[:tag]
    page_num = params[:page]
    if tag.present?
      @tag = Tag.find_by_name(tag)
      if page_num.present?
        @clips = @tag.my_clips page_num
      else
        @clips = @tag.my_clips
      end
      @title = @tag.name
    else
      @title = 'All'
      if page_num.present?
        @clips = Clip.page page_num
      else
        @clips = Clip.page
      end
    end

    respond_to do |format|
      format.html do # index.html.erb
        @tags = Tag.all
      end
      format.json { render :text => @clips.to_json(:include => {:tags => { :except => [:created_at, :updated_at]}})}
    end
  end

  # GET /clips/pinned.json
  def pinned
    @clips = Clip.pinned
    @title = 'Pinned'

    respond_to do |format|
      format.html { render 'index' } # index.html.erb
      format.json { render json: @clips }
    end
  end

  # GET /clips/trashed.json
  def trashed
    @clips = Clip.trashed
    @title = 'Trashed'

    respond_to do |format|
      format.html { render 'index' } # index.html.erb
      format.json { render json: @clips }
    end
  end

  # GET /clips/1
  # GET /clips/1.json
  def show
    @clip = Clip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clip.to_json(
        :include => {:tags => { :except => [:created_at, :updated_at]}})}
    end
  end

  # GET /clips/new
  # GET /clips/new.json
  def new
    @clip = Clip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @clip }
    end
  end

  # GET /clips/1/edit
  def edit
    @clip = Clip.find(params[:id])
  end

  # POST /clips
  # POST /clips.json
  def create
    @clip = Clip.new(params[:clip])

    respond_to do |format|
      if @clip.load and @clip.save
        @clip.tagging
        format.html { redirect_to clips_url, notice: 'Clip was successfully created.' }
        format.json { render json: @clip, status: :created, location: @clip }
      else
        format.html { render action: "new" }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clips/1
  # PUT /clips/1.json
  def update
    @clip = Clip.find(params[:id])
    params[:clip][:tags] = load_tags(params)

    respond_to do |format|
      if @clip.update_attributes(params[:clip])
        format.html { redirect_to @clip, notice: 'Clip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clips/1
  # DELETE /clips/1.json
  def destroy
    @clip = Clip.find(params[:id])
    @clip.destroy

    respond_to do |format|
      format.html { redirect_to clips_url }
      format.json { head :no_content }
    end
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
