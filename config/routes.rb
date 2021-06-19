Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions"
  }
  root "static_pages#show", page: "home"
  get "/pages/:page" => "static_pages#show"
  resources :experts, only: :index
end
