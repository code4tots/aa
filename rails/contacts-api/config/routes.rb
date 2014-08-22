Rails.application.routes.draw do
  resources :contact_shares
  resources :contacts
  resources :users, only: [:index, :create, :destroy, :show, :update] do
    resources :contacts
  end
end
