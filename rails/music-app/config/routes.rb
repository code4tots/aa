Rails.application.routes.draw do
  resources :users, only: [ :create, :new ]
  resource :session, only: [ :create, :new, :destroy ]
  resources :bands
  resources :albums
  resources :tracks
end
