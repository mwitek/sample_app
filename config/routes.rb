SampleApp::Application.routes.draw do
  resources :users
  root :to => "static_pages#home"
  match '/home', :to =>  'static_pages#home'
  match '/about', :to =>  'static_pages#about'
  match '/help', :to =>  'static_pages#help'
  match '/contact', :to =>  'static_pages#contact'
  match '/signup', :to => 'users#new'
end
