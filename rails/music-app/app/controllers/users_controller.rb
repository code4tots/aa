class UsersController < ApplicationController
  def new
  end
  
  def create
    user = User.create!(user_params)
    log_in_user!(user)
    render text: "user #{user.email} successfully created!"
  end
  
  def show
    
  end
  
  private
  
  def user_params
    params[:user].permit(:email, :password)
  end
end
