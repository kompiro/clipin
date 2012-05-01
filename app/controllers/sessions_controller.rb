class SessionsController < ApplicationController
  skip_before_filter :authenticate!, :only => %w[new create]

  def new
    respond_to do |format|
      format.html { render html: {:error => 'authorized error'}, status: :unauthorized } # new.html.erb
      format.json { render json: {:error => 'authorized error'}, status: :unauthorized  }
    end
  end

  def create
    auth = auth_hash
    user = User.where(:provider => auth['provider'],
        :uid => auth['uid']).first || User.create_with_omniauth(auth)
    User.current = user
    session[:user_id] = user.id
    redirect_to '/clips#index'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
