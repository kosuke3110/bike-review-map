Rails.application.routes.draw do
  get 'users/show'
  get 'users/edit'
  get 'users/update'
  devise_for :users
  # get 'shops/search'
  # get 'shops/result'
  root to: 'home#top'
  get 'home/top'
  get 'home/map_test'
  get 'shops/search', to: 'shops#search', as: :search_shops
  get 'shops/result', to: 'shops#result', as: :result_shops
  resources :shops, only: [:show]
  resources :reviews, only: [:new, :create, :edit, :update, :destroy]
  resources :users, only: [:show, :edit, :update]

  # get '/up', to: proc { [200, { 'Content-Type' => 'text/plain' }, ['OK']] }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
