AudioVision::Application.routes.draw do
  root to: 'posts#index'
  get '/:id(/:slug)' => 'posts#show', constraints: { id: /\d+/ }

  get '/reporters'       => 'reporters#index'
  get '/reporters/:slug' => 'reporters#show'

  namespace :outpost do
    root to: 'home#dashboard'
    
    resources :sessions, only: [:create, :destroy]
    get 'login'  => "sessions#new", as: :login
    get 'logout' => "sessions#destroy", as: :logout

    resources :posts
    resources :flatpages
    resources :reporters
    resources :users
    resources :categories
  end


  get '*path' => 'root_path#handle_path'
end
