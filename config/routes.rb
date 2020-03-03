Rails.application.routes.draw do
  
  devise_for          :users
  
  resources           :pages
  resources          :albums
  resources          :groups
  resources      :followings, only:   [:create, :destroy]
  resources           :likes, only:   [:create, :destroy]
  resources        :comments, only:   [:create, :destroy]
  resources     :memberships, only:   [:create, :update, :destroy]
  resources     :friendships, only:   [:create, :update, :destroy]
  resources           :posts, only:   [:create, :show,   :destroy]
  resources        :messages, only:   [:create, :show,   :destroy]
  resources     :discussions, except: [:edit,   :update, :index]
  resources :direct_messages, except: [:edit,   :update]
  resources          :photos, except: [:index]
  
  
  root 'static_pages#home'
  
  get '/help',                     to: 'static_pages#help'
  get '/about',                    to: 'static_pages#about'
  get '/contact',                  to: 'static_pages#contact'
  
  get '/received_friend_requests', to: 'users#received_friend_requests'
  
  resources :users do
    member do
      get :friends
      get :albums
      get :followed_pages
      get :joined_groups
    end
  end
  
  resources :groups do
    member do
      get :members
      get :unconfirmed_members
    end
  end
  
  resources :photos do
    member do
      get :photo_modal
    end
  end
end