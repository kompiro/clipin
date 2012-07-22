class SessionsController < ApplicationController
  skip_before_filter :authenticate!, :only => %w[new create]

  def new
    render html: {:error => 'authorized error'}, status: :unauthorized
  end

  def delete
    session[:user_id] = nil
    cookies.signed[:user_id] = nil
    redirect_to sessions_login_url
  end

  def create
    auth = auth_hash
    user = User.where(:provider => auth['provider'],
        :uid => auth['uid']).first || User.create_with_omniauth(auth)
    User.current = user
    session[:user_id] = user.id
    cookies.signed[:user_id] = {:value => user.id,:expires => 1.year.from_now}
    redirect_to '/clips#index'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
