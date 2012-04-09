Clipin::Application.routes.draw do
  resources :clips

  root :to => "clips#index"
  mount JasmineRails::Engine => "/specs" unless Rails.env.production?
end
