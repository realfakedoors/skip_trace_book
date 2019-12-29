Rails.application.routes.draw do
  
  devise_for :users
  
  root 'static_pages#home'
  
  get '/help',                     to: 'static_pages#help'
  get '/about',                    to: 'static_pages#about'
  get '/contact',                  to: 'static_pages#contact'
  get '/received_friend_requests', to: 'users#received_friend_requests'
  
  resources :users do
    member do
      get :friends
      get :albums
    end
  end
  resources      :albums
  resources      :photos, except: [:index]
  resources :friendships, only:   [:create, :update, :destroy]
  resources       :posts, only:   [:create, :show,   :destroy]
end
