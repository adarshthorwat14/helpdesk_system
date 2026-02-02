Rails.application.routes.draw do
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
end
