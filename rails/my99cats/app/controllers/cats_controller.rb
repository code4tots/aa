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
    cat = Cat.new(cat_params)
    cat.user_id = current_user.id
    cat.save!
    redirect_to cat_url(cat)
  end
  
  def edit
    @cat = Cat.find(params[:id])
  end
  
  def update
    cat = Cat.find(cat_params[:cat][:id])
    if cat.user_id == current_user.id
      cat.update!(cat_params[:cat].permit(Cat.column_names))
    else
      # Malicious user!!!
    end
    redirect_to cat_url(cat)
  end
  
  private
  
  def cat_params
    params[:cat].permit(Cat.column_names)
  end
end
