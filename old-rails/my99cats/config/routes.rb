My99cats::Application.routes.draw do
  resources :cats
  resources :cat_rental_requests do
    member do
      post 'approve'
      post'deny'
    end
  end
  resources :users
  resources :sessions
end
