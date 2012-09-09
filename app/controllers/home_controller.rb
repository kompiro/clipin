class HomeController < ApplicationController
  layout "unauthorized"
  skip_before_filter :authenticate!
  def index
    redirect_to clips_url if current_user.present?
  end
end
