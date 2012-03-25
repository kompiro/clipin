Clipin::Application.routes.draw do
  resources :clips

  root :to => "home#index"
end
