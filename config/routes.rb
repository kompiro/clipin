Clipin::Application.routes.draw do
  resources :tags do
    resources :clips, :only => 'index'
  end

  resources :clips do
    collection do
      get :pinned,:trashed
    end
  end
  root :to => "clips#index"
  resources :sessions, :only => 'new'
  match '/auth/:provider/callback', to: 'sessions#create'
  resources :oauth
  get '/extensions/chrome_oauth', to: 'oauth#chrome'

  mount JasmineRails::Engine => "/specs" unless Rails.env.production?
end
