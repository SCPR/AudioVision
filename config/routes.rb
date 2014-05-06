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
        resources :posts, only: [:index, :show] do
          get '/by_url' => 'posts#by_url', on: :collection
        end

        resources :buckets, only: [:index, :show]

        resources :billboards, only: [:index, :show] do
          get 'current' => 'billboards#current', on: :collection
        end
      end
    end

    namespace :private do
      namespace :v1 do
        resources :posts, only: [:index, :show] do
          get '/by_url' => 'posts#by_url', on: :collection
        end
      end
    end
  end


  concern :previewable do
    patch "preview", on: :member
    post "preview", on: :collection
  end

  ## OUTPOST
  mount Outpost::Engine, at: 'outpost'

  namespace :outpost do
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
