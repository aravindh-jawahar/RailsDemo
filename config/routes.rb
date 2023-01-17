require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  get 'users' => 'users#index', as: 'users'

  get 'articles_list' => 'articles#index'
  get 'comments_list' => 'comments#index'
  resources :articles, only: [:destroy, :create]
  resources :comments, only: [:destroy, :create]
  post 'sign_up' => 'sessions#create', as: 'sign_up'
  get 'sign_in' => 'sessions#login', as: 'sign_in'
  delete 'delete/:id' => 'users#delete', constraints: { id: /.*/ }
  delete 'sign_out' => 'sessions#destroy', as: 'sign_out'

end
