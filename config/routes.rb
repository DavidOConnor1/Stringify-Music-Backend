Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :songs
      resources :artists  

      get 'user', to: 'users#show'
      patch 'user', to: 'users#update'
      put 'user', to: 'user#update'

      post 'upgrade_to_artist', to 'users#upgrade_to_artist'
      get 'public_songs', to: 'songs#public_index'

    end
  end
  
  root to: "home#index"

  
  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  post "signup", controller: :signup, action: :create
  delete "signin", controller: :signin, action: :destroy
end