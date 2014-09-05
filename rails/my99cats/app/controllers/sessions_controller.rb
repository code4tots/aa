class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by_credentials(
      params[:user]['user_name'], 
      params[:user]['password'])
    
    user.reset_session_token!
    session['session_token'] = user.session_token
    
    redirect_to cats_url
  end
  
  def destroy
    current_user.reset_session_token!
    session['session_token'] = nil
    redirect_to new_session_url
  end
end
