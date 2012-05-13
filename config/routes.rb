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
  scope "/oauth" do
    resources :apps
  end

  match "/oauth/authorize" => "apps#authorize", :via => %w[get post]
  match "/oauth/allow" => "apps#allow", :via => "put"
  match "/oauth/access_token" => "apps#access_token", :via => "get"
  get '/extensions/chrome_oauth', to: 'oauth/apps#chrome'
  namespace :api do
    namespace :v1 do
      resources :clips
    end
  end

  mount JasmineRails::Engine => "/specs" unless Rails.env.production?
end
