class GoalsController < ApplicationController
  def index
  end
  
  def new
    @goal = Goal.new
  end
  
  def create
    render json: 'Your hat does not appear to be white.' if current_user.nil?
    
    goal = Goal.new(params[:goal].permit(:name, :status, :access, :description))
    goal.user = current_user
    goal.save!
    
    redirect_to goals_url
  end
end
