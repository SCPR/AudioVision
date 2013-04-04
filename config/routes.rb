AudioVision::Application.routes.draw do
  root to: 'home#homepage'
  
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
    resources :billboards
    
    get "*path" => 'errors#not_found'
  end

  get '*path' => 'root_path#handle_path'
end
