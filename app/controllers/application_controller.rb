class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user

  def current_user
    unless session[:user_id].nil?
      user = User.find session[:user_id]
      User.current = user
      return user
    end
  end
end
