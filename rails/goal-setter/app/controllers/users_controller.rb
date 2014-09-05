class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    user = User.create!(user_params)
    log_in!(user)
    redirect_to users_url
  end
  
  def show
    @user = User.find(params[:id])
  end
end
