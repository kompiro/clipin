class ApplicationController < ActionController::Base
  protect_from_forgery
  def current_user
    unless session[:user_id].nil?
      User.find session[:user_id]
    end
  end
end
