class CatsController < ApplicationController
  
  def index
    @cats = Cat.order(:id)
    
    ## If there is no explicit render call, the following is implied
    # render :index
  end
  
  def show
    @cat = Cat.find_by_id(params[:id])
    
    ## If there is no explicit render call, the following is implied
    # render :show
  end
  
  def create
    Cat.create!(params[:cat].permit(Cat.column_names))
    redirect_to cats_url
  end
  
  def update
    Cat.find_by_id(params[:id]).update!(params[:cat].permit(Cat.column_names))
    redirect_to cats_url
  end
end
