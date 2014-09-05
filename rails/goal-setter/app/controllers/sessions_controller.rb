class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by_credentials(user_params[:username], user_params[:password])
    if user.nil?
      flash[:notice] = 'You have failed to login'
    else
      flash[:notice] = 'you have successfully logged in'
      log_in! user
    end
    redirect_to users_url
  end

  def destroy
    log_out!
    redirect_to new_session_url
  end
end
