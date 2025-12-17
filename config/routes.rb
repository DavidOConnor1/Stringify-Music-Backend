Rails.application.routes.draw do
   get '/health', to: 'api#health'
  get '/', to: 'api#health'
  namespace :api do
    namespace :v1 do
      resources :songs
      resources :artists
      resources :playlists, only: [:index, :show, :create, :update, :destroy] do
        member do
          post 'add_song'
          delete 'remove_song'
        end
      end 

      #api routes
      get 'music/search', to: 'music#search'
      get 'music/featured_artists', to: "music#featured_artists"
      get 'music/featured_songs', to: "music#featured_songs"
      get 'music/new_releases', to: "music#new_releases"

      #user routes
      get 'user', to: 'users#show'
      patch 'user', to: 'users#update'
      put 'user', to: 'users#update' 

      #become an artist routes
      post 'upgrade_to_artist', to: 'users#upgrade_to_artist'
      get 'public_songs', to: 'songs#public_index'

      #user specific playlists
      get 'user/:user_id/playlists', to: 'playlist#index'
    end
  end
  #home page route
  root to: "home#index"

  #account creation routes
  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  post "signup", controller: :signup, action: :create
  delete "signin", controller: :signin, action: :destroy
end