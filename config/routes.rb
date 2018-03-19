Rails.application.routes.draw do
  root 'books#index'

  resources :books
  get '/read/:id(.:format)', to: 'books#read', as: :read
  get '/admin', to: 'users#admin', as: :admin
  patch '/user/:id(.:format)', to: 'users#adminMake', as: :status_change
  get '/categories', to: 'books#categories', as: :categories
  get '/category/:category(.:format)', to: 'books#category', as: :category
  get '/author/:author(.:format)', to: 'books#author', as: :author
  get '/search', to: 'books#search', as: :search
  get '/signup', to: 'users#signup', as: :signupPage
  get '/signin', to: 'users#signin', as: :loginPage
  post '/login', to: 'users#login', as: :login
  get '/login', to: 'users#register', as: :register
  get '/logout', to: 'users#logout', as: :logout

  post '/comment/:postid(.:format)', to: 'comments#add', as: :comment
  delete '/comment/:id(.:format)', to: 'comments#destroy', as: :delete_comment
end
