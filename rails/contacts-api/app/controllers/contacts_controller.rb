class ContactsController < ApplicationController
  def create
    contact = Contact.create!(contact_params)
    render json: contact
  end
  
  def destroy
    contact = Contact.destroy(params[:id])
    render json: contact
  end
  
  def index
    render json: Contact.where(user_id: params[:user_id])
  end
  
  def show
    render json: Contact.find(params[:id])
  end
  
  def update
    render json: Contact.update(params[:id],contact_params)
  end
  
  private
  
  def contact_params
    params.require(:contact).permit(Contact.column_names)
  end
end
