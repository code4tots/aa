class SessionsController < ApplicationController
  def new
    @user = User.new
  end
  def create
    
    redirect_to users_url
  end
end
