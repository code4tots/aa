class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def destroy
    User.destroy(params[:id])
    render text: "destroyed user #{params[:id]}"
  end
  
  def index
    render json: User.all
  end
  
  def show
    render json: User.find_by_id(params[:id])
  end
  
  def update
    user = User.find_by_id(params[:id])
    if user.update(params[:user].permit(User.column_names))
      render json: user
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params[:user].permit(User.column_names)
  end
end
