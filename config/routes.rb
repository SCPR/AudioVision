  AudioVision::Application.routes.draw do
  root to: 'home#index'

  get '/slideshows'  => 'posts#index', defaults: { media_type: "slideshow" }
  get '/:id(/:slug)' => 'posts#show', constraints: { id: /\d+/ }

  get '/staff'       => 'authors#index'
  get '/staff/:slug' => 'authors#show'

  get '*path'        => 'flatpages#show'
end
