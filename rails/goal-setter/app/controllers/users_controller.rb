class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    User.create!(user_params)
    redirect_to users_url
  end
  
  private
  
  def user_params
    params[:user].permit(:username, :password)
  end
end
