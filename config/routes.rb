Rails.application.routes.draw do
  root 'books#index'

  # Books
  resources :books
  get '/read/:id(.:format)', to: 'books#read', as: :read
  get '/whattoread', to: 'books#whattoread', as: :whattoread
  get '/admin', to: 'users#admin', as: :admin
  patch '/user/:id(.:format)', to: 'users#adminMake', as: :status_change
  get '/categories', to: 'books#categories', as: :categories
  get '/categories/search', to: 'books#categoriesSearch', as: :categoriessearch
  get '/category/:category(.:format)', to: 'books#category', as: :category
  get '/author/:author(.:format)', to: 'books#author', as: :author

  # Authorisation
  get '/search', to: 'books#search', as: :search
  get '/signup', to: 'users#signup', as: :signupPage
  get '/signin', to: 'users#signin', as: :loginPage
  post '/login', to: 'users#login', as: :login
  get '/login', to: 'users#register', as: :register
  get '/logout', to: 'users#logout', as: :logout

  # Comments
  post '/comment/:postid(.:format)', to: 'comments#add', as: :comment
  delete '/comment/:id(.:format)', to: 'comments#destroy', as: :delete_comment

  #   Api
  get '/api/books', to: 'api#getBooks', as: :api_books

  get 'api/categories', to: 'api#getCategories', as: :api_categories

  get 'api/users', to: 'api#getUsers', as: :api_users
  post 'api/users', to: 'api#putUsers', as: :api_users_put
end
