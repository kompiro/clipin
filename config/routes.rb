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
  mount JasmineRails::Engine => "/specs" unless Rails.env.production?
end
