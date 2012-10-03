class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :app_last_updated_at,:authenticate!

  def current_user
    unless session[:user_id].nil?
      user = User.find session[:user_id]
      User.current = user
      return user
    end
    unless cookies.signed[:user_id].nil?
      user_id = cookies.signed[:user_id]
      session[:user_id] = user_id
      user = User.find user_id
      User.current = user
      return user
    end
  end

  def authenticate!
    redirect_to root_url unless current_user.present?
  end

  def app_last_updated_at
    if File.exist?(Rails.root + "REVISION")
      timezone = "Tokyo"
      @app_last_updated_at = File.atime(Rails.root + "REVISION").in_time_zone( timezone )
    else
      @app_last_updated_at = "dev"
    end
  end
end
