class CatRentalRequestsController < ApplicationController
  def new
    
  end
  
  def create
    CatRentalRequest.create!(params[:cat_rental_request].permit(CatRentalRequest.column_names))
    redirect_to cat_rental_requests_url
  end
  
  def approve
    request = CatRentalRequest.find_by_id(params[:id])
    request.approve!
    redirect_to cat_url(request.cat)
  end
  
  def deny
    request = CatRentalRequest.find_by_id(params[:id])
    request.deny!
    redirect_to cat_url(request.cat)
  end
  
end
