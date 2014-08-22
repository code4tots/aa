class ContactSharesController < ApplicationController
  def create
    render json: ContactShare.create(contact_share_params)
  end
  
  def destroy
    render json: ContactShare.destroy(params[:id])
  end
  
  private
  
  def contact_share_params
    params.require(:contact_share).permit(ContactShare.column_names)
  end
end
