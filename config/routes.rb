Rails.application.routes.draw do

  # Web (HTML)
  devise_for :users
  root "tickets#index"
  get "user_dashboard", to: "dashboard#user_dashboard"

  resources :tickets do
    member do
      patch :assign
      patch :update_status
      patch :confirm_resolution
      patch :mark_resolved
      patch :close
    end
    resources :comments, only: :create
  end

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end

  # API
  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      resources :tickets
      resources :comments, only: [:index, :create, :destroy]
      resources :notifications, only: [:index, :update]
      patch 'users/update_fcm_token', to: 'users#update_fcm_token'
    end
  end

end
