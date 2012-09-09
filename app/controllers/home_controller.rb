class HomeController < ApplicationController
  layout "unauthorized"
  skip_before_filter :authenticate!
  def index
  end
end
