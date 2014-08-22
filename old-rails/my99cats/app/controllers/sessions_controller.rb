class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    
    if user.nil?
      render json: 'Invalid credentials'
    else
      user.reset_session_token!
      session[:session_token] = user.session_token
      render json: user
    end
  end
  
  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end
end
