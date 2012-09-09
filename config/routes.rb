Clipin::Application.routes.draw do
  get "welcome/index"

  mount Doorkeeper::Engine => '/oauth'

  resources :tags do
    resources :clips, :only => 'index'
  end

  resources :clips do
    collection do
      get :pinned,:trashed
    end
  end
  root :to => "home#index"
  match '/login', to: 'sessions#new'
  match '/logout', to: 'sessions#delete'
  match '/auth/:provider/callback', to: 'sessions#create'

  namespace :api do
    namespace :v1 do
      resources :clips
    end
  end

end
