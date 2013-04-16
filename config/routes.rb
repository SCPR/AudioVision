AudioVision::Application.routes.draw do
  root to: 'home#homepage'
  
  get '/:id/:slug' => 'posts#show', constraints: { id: /\d+/ }, as: :post

  get '/about'          => 'reporters#index', as: :reporters
  get '/about/:slug'    => 'reporters#show', as: :reporter

  get '/archive(/:category)'    => 'feed#index', as: :archive
  get '/feed(/:category)'       => 'feed#index', as: :feed, defaults: { format: "xml" }


  ## API
  namespace :api, defaults: { format: "json" } do
    scope module: "public" do
      namespace :v1 do  
        get '/posts'        => 'posts#index'
        get '/posts/by_url' => 'posts#by_url'
        get '/posts/:id'    => 'posts#show'
      end
    end
    
    namespace :private do
      namespace :v1 do
        get '/posts'        => 'posts#index'
        get '/posts/by_url' => 'posts#by_url'
        get '/posts/:id'    => 'posts#show'
      end
    end
  end


  concern :previewable do
    patch "preview", on: :member
    post "preview", on: :collection
  end

  ## OUTPOST
  namespace :outpost do
    root to: 'home#dashboard'
    
    resources :sessions, only: [:create, :destroy]
    get 'login'  => "sessions#new", as: :login
    get 'logout' => "sessions#destroy", as: :logout

    resources :posts, concerns: [:previewable]
    resources :billboards, concerns: [:previewable]

    resources :flatpages
    resources :reporters
    resources :users
    resources :categories
    resources :buckets
    
    get "*path" => 'errors#not_found'
  end


  get '*path' => 'root_path#handle_path', as: :root_slug
end
