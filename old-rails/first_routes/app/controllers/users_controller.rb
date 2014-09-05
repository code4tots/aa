class UsersController < ApplicationController
  # def index
  #   render text: "I'm in the index action! Got #{params}"
  # end
  
  def index
    render json: User.all
  end
  
  def create
    user = User.new(params[:user].permit(:email, :name))
    if user.save
      render json: user
    else
      render(
        json: user.errors.full_messages, status: :unprocessable_entity)
    end
  end
  
  def show
    render json: User.find_by_id(params[:id])
  end
  
  def update
    User.update(params[:id], params[:user].permit(:email, :name))
    render json: User.find_by_id(params[:id])
  end
  
  def destroy
    User.destroy(params[:id])
    render text: "User #{params[:id]} destroyed!"
  end
end
