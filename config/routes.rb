Clipin::Application.routes.draw do
  resources :tags do
    resources :clips, :only => 'index'
  end

  resources :clips do
    collection do
      get :pinned,:trashed
    end
  end
  root :to => "home#index"
  match '/auth/:provider/callback', to: 'sessions#create'
  mount JasmineRails::Engine => "/specs" unless Rails.env.production?
end
