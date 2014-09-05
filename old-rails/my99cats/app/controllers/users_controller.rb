class UsersController < ApplicationController
  def new
    
  end
  
  def create
    user = User.new(params.require(:user).permit(:user_name, :password))
    user.save!
    render json: user
  end
end
