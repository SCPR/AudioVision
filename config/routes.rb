AudioVision::Application.routes.draw do
  root to: 'home#index'

  namespace :outpost do
    root to: 'home#dashboard'
    
    resources :sessions, only: [:create, :destroy]
    get 'login'  => "sessions#new", as: :login
    get 'logout' => "sessions#destroy", as: :logout

    resources :posts
    resources :flatpages
    resources :reporters
  end

  get '/slideshows'  => 'posts#index', defaults: { media_type: "slideshow" }
  get '/reporters'       => 'reporters#index'
  get '/reporters/:slug' => 'reporters#show'

  get '/:id(/:slug)' => 'posts#show', constraints: { id: /\d+/ }
  get '*path' => 'flatpages#show'
end
