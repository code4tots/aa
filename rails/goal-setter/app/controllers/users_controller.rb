class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    User.create!(user_params)
    redirect_to users_url
  end
  
  def show
    @user = User.find(params[:id])
  end
end
