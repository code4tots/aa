class UsersController < ApplicationController
  def new
  end
  
  def create
    User.create!(user_params)
    redirect_to cats_url
  end
  
  private
  
  def user_params
    params.require(:user).permit(User.column_names, :password)
  end
end
