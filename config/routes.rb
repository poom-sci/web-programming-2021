Rails.application.routes.draw do
  resources :follows
  get 'main',to:"main#main"
  post 'login',to:"main#login"
  get 'logout',to:"main#logout"
  get 'register',to:"main#register"
  post 'register',to:"main#register_create"
  get 'feed',to:"main#feed"
  get 'create_post', to:"main#create_post"
  post 'create_new_post', to:"main#create_new_post"
  get 'profile/:name', to:'main#profile'
  get 'profile', to:'main#profile'
  post 'follow', to:'main#follow'
  get 'destroy_post', to:'main#destroy_post'
  get 'other_user',to:'main#other_user'
  resources :posts
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
