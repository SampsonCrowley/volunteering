require 'sidekiq/web'
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'states#index'
  resources :states
  resources :admin
  resource :session
  get '/logout' => 'sessions#destroy'
  get '/login' => 'sessions#new'
end
