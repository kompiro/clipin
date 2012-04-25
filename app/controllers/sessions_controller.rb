class SessionsController < ApplicationController
  def create
    puts auth_hash
    redirect_to '/clips#index'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
