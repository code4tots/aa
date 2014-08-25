class GoalsController < ApplicationController
  def index
  end
  
  def new
    @goal = Goal.new
  end
  
  def create
    if current_user.nil?
      render json: 'Your hat does not appear to be white.'
      return nil
    end
    
    goal = Goal.new(params[:goal].permit(:name, :status, :access, :description))
    goal.user = current_user
    goal.save!
    
    redirect_to goals_url
  end
  
  def edit
    @goal = Goal.find(params[:id])
    if @goal.nil?
      render json: "that goal doesn't exist"
    end
  end
  
  def show
    @goal = Goal.find(params[:id])
    if @goal.nil?
      render json: "that goal doesn't exist"
    end
  end
  
  def update
    goal = Goal.find(params[:id])
    
    if goal.nil?
      render json: "that goal doesn't exist"
      return nil
    end
    
    if current_user.nil? || current_user.id != goal.user_id
      render json: 'Your hat does not appear to be white.'
      return nil
    end
    
    goal.update!(params[:goal].permit(:name, :status, :access, :description))
    
    redirect_to goals_url
  end
end
