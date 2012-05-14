class AppsController < ApplicationController
  respond_to :html
  skip_before_filter :authenticate!, :only => %w[chrome]

  def new
    @client = OAuth2::Model::Client.new
  end

  def create
    data = params[:oauth]
    @client = OAuth2::Model::Client.new()
    @client.name = data[:name]
    @client.redirect_uri = data[:redirect_uri]

    respond_to do |format|
      if @client.save
        format.html { redirect_to root_url, notice: 'OAuth Application was successfully registered.' }
        format.json { render json: @client.to_json(:methods => :client_secret)}
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def authorize
    @owner  = User.find_by_id(session[:user_id])
    if @owner.nil?
      redirect_to :new_session
    end
    @oauth2 = OAuth2::Provider.parse(@owner, env)

    if @oauth2.redirect?
      redirect_to @oauth2.redirect_uri, status: @oauth2.response_status
      return
    end

    if @oauth2.response_body.present?
      response.headers = @oauth2.response_headers
      render :text => @oauth2.response_body ,status: @oauth2.response_status
    else
      render action: 'authorize'
    end
  end

  def access_token
    @owner  = User.find_by_id(session[:user_id])
    if @owner.nil?
      redirect_to :new_session
    end
    @oauth2 = OAuth2::Provider.parse(@owner, env)
    @access_token = { :access_token => @oauth2.access_token }
    render :json => @access_token.to_json
  end

  def allow
    @user = User.find_by_id(session[:user_id])
    @oauth2 = OAuth2::Provider::Authorization.new(@user, params[:oauth])

    @oauth2.grant_access!
    render :json => {:redirect_uri => @oauth2.redirect_uri}.to_json, status: @oauth2.response_status # this api accessed by json
  end

  def show
    @client = OAuth2::Model::Client.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @client }
    end
  end

  def chrome
  end
end
