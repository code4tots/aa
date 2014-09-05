class UsersController < ApplicationController
  def index
    render text: "I'm in the index action!"
  end
  
  def create
    user = User.new(params[:user].permit(User.column_names))
    user.save!
    render json: user
  end
  
  def show
    render json: User.find_by_id(params[:id])
  end
  
  def update
    user = User.find_by_id(params[:id])
    user.update!(params[:user].permit(User.column_names))
    render json: user
  end
  
  def destroy
    User.destroy(params[:id])
    render text: "destroyed user #{params[:id]}"
  end
end
