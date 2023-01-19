require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  resources :users, only: [:destroy, :index]
  resources :articles, only: [:destroy, :index, :create]
  resources :comments, only: [:destroy, :create]
  post 'sign_up' => 'sessions#create', as: 'sign_up'
  get 'sign_in' => 'sessions#login', as: 'sign_in'
  delete 'sign_out' => 'sessions#destroy', as: 'sign_out'

end
