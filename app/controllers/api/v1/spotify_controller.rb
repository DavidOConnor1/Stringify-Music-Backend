Module Api 
    Module V1
    class SpotifyController < ApplicationController
        before_action :authorize_access_request!

        #Spotify OAuth Flow
        def authenticate
            service = SpotifyService.new
            redirect_to service.auth_url
        end

        #handle spotify callback
        def callback
            code = params[:code]
            error = params[:error]

            if error
                render json: {error: "Spotify Authorization Failed: #{error}"}, status :unauthorized
                return
            end

            if code 
                service = SpotifyService.new
                token_data = service.exchange_code_for_token(code)

                if token_data
                    #save spotify tokens to user
                    current_user.update(
                        spotify_access_token: token_data['access_token']
                        spotify_refresh_token: token_data['refresh_token']
                        spotify_token_expires_at: Time.current + token_data['expires_in'].seconds
                    )

                    #get a users spotify profile
                    spotify_service = SpotifyService.new(token_data['access_token'])
                    spotify_profile = spotify_service.get_user_profile

                    render json: {
                        message: 'Spotify connected Successfully',
                        spotify_profile: spotify_profile,
                        access_token: token_data['access_token']
                    }
                else
                    render json: { error: 'error to get access token from spotify' }, status :bad_request
                end 
            else
                render json: {error: 'no authorizatio code received'}, status: bad_request
            end
        end

        def search
            query = params[:query]
            limit = params[:limit] || 20

            if query.blank?
                render json: {error: 'query parameter is required'}, status: :bad_request
                return
            end

            service = SpotifyService.new(current_user.spotify_access_token)
            results = service.search_music(query, limit)

            render json: {
                query: query,
                results: results,
                total: results.size
            }
        end

        #featured for discovery
        def featured
            limit = params[:limit] || 10

            service = SpotifyService.new(current_user.spotify_access_token)
            playlists = service.get_featured_playlists(limit)

            render json: {
                playlists: playlists,
                total: playlists.size
            }
        end

        #new releases
        def new_releases
            limit = params[:limit] || 20

            service = SpotifyService.new(current_user.spotify_access_token)
            releases = service.get_new_releases(limit)

            render json: {
                releases: releases
                total: releases.size
            }
        end

        def disconnect
            current_user.update(
                spotify_access_token: nil,
                spotify_refresh_token: nil,
                spotify_token_expires_at: nil
            )

            render json: {message: 'Spotify disconnected sucessfully'}
        end
    end
end
end
