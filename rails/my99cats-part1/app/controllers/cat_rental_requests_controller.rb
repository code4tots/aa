class CatRentalRequestsController < ApplicationController
  def new
  end
  
  def create
    cat_rental_request = CatRentalRequest.create!(cat_rental_request_params)
    redirect_to cat_url(cat_rental_request.cat)
  end
  
  def approve
    cat_rental_request = CatRentalRequest.find(params[:id])
    cat_rental_request.approve!
    redirect_to cat_url(cat_rental_request.cat)
  end
  
  def deny
    cat_rental_request = CatRentalRequest.find(params[:id])
    cat_rental_request.deny!
    redirect_to cat_url(cat_rental_request.cat)
  end
  
  private
  
  def cat_rental_request_params
    params[:cat_rental_request].permit(CatRentalRequest.column_names)
  end
  
end
