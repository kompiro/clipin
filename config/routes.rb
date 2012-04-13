Clipin::Application.routes.draw do
  resources :tags

  resources :clips do
    collection do
      get :pinned
    end
  end

  root :to => "clips#index"
  mount JasmineRails::Engine => "/specs" unless Rails.env.production?
end
