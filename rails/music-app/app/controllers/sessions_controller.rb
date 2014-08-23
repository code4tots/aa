class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_credentials(params[:user][:email], params[:user][:password])
    if user.nil?
      render text: 'failed login'
    else
      log_in_user!(user)
      render text: 'successfully logged in'
    end
  end
  
  def destroy
    log_out!
    render text: 'successfully logged out'
  end
end
