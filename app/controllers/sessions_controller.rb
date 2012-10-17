class SessionsController < ApplicationController
  skip_before_filter :authenticate!, :only => %w[new create]
  layout "unauthorized",:only => [:new,:create]

  def new
    render html: {:error => 'authorized error'}, status: :unauthorized
  end

  def delete
    session[:user_id] = nil
    cookies.signed[:user_id] = nil
    redirect_to root_path
  end

  def create
    auth = auth_hash
    if user.present?
      existed = true
    else
      user = User.create_with_omniauth(auth)
    end
    User.current = user
    session[:user_id] = user.id
    cookies.signed[:user_id] = {:value => user.id,:expires => 1.year.from_now}
    if existed
      flash[:success] = 'Welcome Back!'
    else
      flash[:success] = 'Welcome!'
    end
    redirect_to clips_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
