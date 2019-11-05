Rails.application.routes.draw do
  
  devise_for :users
  
  root 'static_pages#home'
  
  get '/help',      to: 'static_pages#help'
  get '/about',     to: 'static_pages#about'
  get '/contact',   to: 'static_pages#contact'
  
  resources :users do
    member do
      get :friends
    end
  end
  resources :posts, only: [:create, :destroy, :show]
  
end
