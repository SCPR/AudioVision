  AudioVision::Application.routes.draw do
  root to: 'home#index'

  get '/slideshows'  => 'posts#index', defaults: { media_type: "slideshow" }
  get '/:id(/:slug)' => 'posts#show', constraints: { id: /\d+/ }

  get '/reporters'       => 'reporters#index'
  get '/reporters/:slug' => 'reporters#show'

  get '*path'        => 'flatpages#show'

  namespace :outpost do
    resources :posts
    resources :reporters
  end
end
