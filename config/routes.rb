Lelylan::Application.routes.draw do

  namespace :oauth do
    get    "authorization" => "oauth_authorize#show", defaults: { format: "html" }
    post   "authorization" => "oauth_authorize#create", defaults: { format: "html" }
    delete "authorization" => "oauth_authorize#destroy", defaults: { format: "html" }
    delete "token/:id" => "oauth_token#destroy", defaults: { format: "json" }
    post   "token" => "oauth_token#create", defaults: { format: "json" }
  end

  get "log_out" => "sessions#destroy", as: "log_out"
  get "log_in"  => "sessions#new", as: "log_in"
  get "vpsa_log_in"  => "vpsa_user_sessions#new", as: "vpsa_log_in"

  get "sign_up" => "users#new",        as: "sign_up"
  get "users/show" => "users#show"
  get "users/edit" => "users#edit"

  resources :users
  resources :sessions
  resources :vpsa_user_sessions
  resources :scopes

  resources :clients do
    put :block, on: :member
    put :unblock, on: :member
  end

  resources :accesses do
    put :block, on: :member
    put :unblock, on: :member
  end

  root :to => "sessions#new"

  resources :terceiros, defaults: { format: "json" }
  resources :entidades, defaults: { format: "json" }
  resources :pedidos, defaults: { format: "json" }
  resources :produtos, defaults: { format: "json" }
end