class OauthController < ApplicationController
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
        format.json { render json: @client, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
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
