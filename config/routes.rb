Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions"
  }
  root "static_pages#show", page: "home"
  get "/pages/:page" => "static_pages#show"

  resources :experts, only: [:index, :show], param: :display_id
  resources :stocks, only: [:index, :show], param: :display_id
  resources :posts, except: [:edit, :update, :delete], param: :display_id

  # Not edit
  resources :not_found, only: :index
  get "*path", controller: "application", action: "render_404"
end
