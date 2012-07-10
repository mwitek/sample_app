SampleApp::Application.routes.draw do
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  root :to => "static_pages#home"
  match '/home', :to =>  'static_pages#home'
  match '/about', :to =>  'static_pages#about'
  match '/help', :to =>  'static_pages#help'
  match '/contact', :to =>  'static_pages#contact'
  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy', :via => :delete
end
