SampleApp::Application.routes.draw do
  root :to => "static_pages#home"
  match '/home', :to =>  'static_pages#home'
  match '/about', :to =>  'static_pages#about'
  match '/help', :to =>  'static_pages#help'
  match '/contact', :to =>  'static_pages#contact'
  match '/signup', :to => 'users#new'
  get "static_pages/home"
  get "static_pages/about"
  get "static_pages/help"
  get "static_pages/contact"
  get "users/new"
end
