Clipin::Application.routes.draw do
  get "welcome/index"
  use_doorkeeper

  resources :tags do
    resources :clips, :only => 'index'
  end

  resources :clips do
    collection do
      get :pinned,:search
    end
  end
  get '/g/:url' => 'clips#create_by_bookmarklet',:constraints => { :url => /.*/ }

  root :to => "home#index"
  match '/howto', to: 'home#howto', via: [:get,:post]
  match '/logout', to: 'sessions#delete', via: [:get,:post]
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get,:post]
  match '/auth/failure', to: 'home#index', via: [:get,:post]

  namespace :api do
    namespace :v1 do
      resources :clips
    end
  end

end
