Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions"
  }
  root "static_pages#show", page: "home"
  get "/pages/:page" => "static_pages#show"

  resources :experts, only: [:index, :show], param: :display_id
  resources :stocks, only: [:index, :show], param: :display_id
  resources :posts, except: :destroy, param: :display_id
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :update, :destroy]
  resources :follow_experts, only: [:create, :destroy]
  resources :searches, only: :index
  resources :votes, only: :create
  resources :follow_stocks, only: [:create, :destroy]
  resources :notifications, only: :index

  # Not edit
  resources :not_found, only: :index
  get "*path", controller: "application", action: "render_404"
end
