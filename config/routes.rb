Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :songs
      resources :artists

      #Spotify routes
    get 'spotify/authenticate', to: 'spotify#authenticate'
    get 'spotify/callback', to: 'spotify#callback'
    get 'spotify/search', to: 'spotify#search'
    get 'spotify/featured', to: 'spotify#featured'
    get 'spotify/new-releases', to: 'spotify#new_releases'
    get 'spotify/recommendations', to: 'spotify#recommendations'
    get 'spotify/profile', to: 'spotify#profile'
    delete 'spotify/disconnect', to: 'spotify#disconnect'

      get 'user', to: 'users#show'
      patch 'user', to: 'users#update'
      put 'user', to: 'users#update' 

   
      post 'upgrade_to_artist', to: 'users#upgrade_to_artist'
      get 'public_songs', to: 'songs#public_index'
    end
  end
  
  root to: "home#index"

  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  post "signup", controller: :signup, action: :create
  delete "signin", controller: :signin, action: :destroy
end