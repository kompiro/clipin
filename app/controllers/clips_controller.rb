class ClipsController < ApplicationController

  @@mutex = Mutex.new

  # GET /clips
  # GET /clips.json
  def index
    tag = params[:tag]
    trashed = params[:trashed]
    pinned = params[:pinned]
    page_num = params[:page]
    updated_at = params[:date]

    @clips = current_user.clips
    if trashed
      @clips = @clips.trashed
    else
      @clips = @clips.not_trashed
    end
    if tag.present?
      @tag = Tag.find_by_name(tag)
      @clips = @clips.tag(@tag)
    end
    if pinned
      @clips = @clips.pinned
    end
    if updated_at
      updated_at = Time.parse updated_at
      @clips = @clips.updated_at updated_at
    end
    if page_num
      @clips = @clips.page page_num
    else
      @clips = @clips.page
    end

    @tags = current_user.tags
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :text => @clips.to_json(:include => {:tags => { :except => [:created_at, :updated_at]}})}
    end
  end

  # GET /clips/search.json
  def search
    query = params[:q]
    page_num = params[:page]

    @title = 'Search'
    if page_num.present?
      @clips = current_user.clips.search(query).page(page_num)
    else
      @clips = current_user.clips.search(query).page
    end

    @tags = current_user.tags
    respond_to do |format|
      format.html { render 'index' }
      format.json { render :text => @clips.to_json(:include => {:tags => { :except => [:created_at, :updated_at]}})}
    end
  end

  # GET /clips/pinned.json
  def pinned
    @clips = Clip.pinned current_user
    @title = 'Pinned'

    respond_to do |format|
      format.html { render 'index' } # index.html.erb
      format.json { render json: @clips }
    end
  end

  # GET /clips/trashed.json
  def trashed
    @clips = Clip.trashed current_user
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
    url = params[:clip][:url]
    do_create url
  end

  def create_by_bookmarklet
    url =  params[:url]
    do_create(url,true)
    respond_to do |format|
      format.js { render action: "bookmarklet",layout: false }
      format.html { render text: "nop"}
    end
    return
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
      t =  Tag.find_or_create_by_name_and_user_id(tag,current_user.id)
      loaded_tags << t
    end
    loaded_tags
  end

  def do_create(url,jump_render=false)
    url = recover_url url
    url_info = UrlInfo.find_by_url url
    unless url_info.nil?
      @clip = Clip.find_by_url_info_id_and_user_id url_info.id,current_user.id
      unless @clip.nil?
        @clip.clip_count = @clip.clip_count + 1
        if jump_render
          @clip.save
          return
        end
        respond_to do |format|
          if @clip.save
            format.json { render json: @clip, status: :ok, location: @clip }
          else
            format.json { render json: @clip.errors, status: :unprocessable_entity }
          end
        end
        return
      end
    end
    @clip = Clip.new({:url => url})
    @clip.user = current_user
    loaded = false

    @@mutex.synchronize do
      loaded = @clip.load and @clip.save
      @clip.tagging if loaded
    end
     return if jump_render
    respond_to do |format|
      if loaded
        format.html { redirect_to clips_url, notice: 'Clip was successfully created.' }
        format.json { render json: @clip, status: :created, location: @clip }
      else
        format.html { redirect_to clips_url, :flash => {error: "Error #{@clip.errors.full_messages.join(' ')}"} }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  def recover_url(url)
    if url.nil?
      return url
    end
    if url.start_with?('http:')
      return 'http://' + url.scan(/http:\/\/?(.*)/)[0][0]
    end
    if url.start_with?('https:')
      return 'https://' + url.scan(/https:\/\/?(.*)/)[0][0]
    end
  end
end
