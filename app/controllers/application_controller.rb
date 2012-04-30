class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate!

  def current_user
    unless session[:user_id].nil?
      user = User.find session[:user_id]
      User.current = user
      return user
    end
  end
  def authenticate!
    redirect_to new_session_url unless current_user.present?
  end
end
