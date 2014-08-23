class CatsController < ApplicationController
  def index
    @cats = Cat.all
  end
  
  def show
    @cat = Cat.find(params[:id])
  end
  
  def new
    @cat = Cat.new
  end
  
  def create
    cat = Cat.create!(cat_params)
    redirect_to cat_url(cat)
  end
  
  def edit
    @cat = Cat.find(params[:id])
  end
  
  def update
    cat = Cat.update(params[:id], cat_params)
    redirect_to cat_url(cat)
  end
  
  private
  
  def cat_params
    params[:cat].permit(Cat.column_names)
  end
end
