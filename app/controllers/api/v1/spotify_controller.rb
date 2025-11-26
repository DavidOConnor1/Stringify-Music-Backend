module Api
  module V1
    class SpotifyController < ApplicationController
      before_action :authorize_access_request!

      # Start Spotify OAuth flow
      def authenticate
        service = SpotifyService.new
        redirect_to service.auth_url
      end

      # Handle Spotify callback
      def callback
        code = params[:code]
        error = params[:error]

        if error
          render json: { error: "Spotify authorization failed: #{error}" }, status: :unauthorized
          return
        end

        if code
          service = SpotifyService.new
          token_data = service.exchange_code_for_token(code)

          if token_data
            # Save Spotify tokens to user
            current_user.update(
              spotify_access_token: token_data['access_token'],
              spotify_refresh_token: token_data['refresh_token'],
              spotify_token_expires_at: Time.current + token_data['expires_in'].seconds
            )

            # Get user's Spotify profile
            spotify_service = SpotifyService.new(token_data['access_token'])
            spotify_profile = spotify_service.get_user_profile

            render json: {
              message: 'Spotify connected successfully',
              spotify_profile: spotify_profile,
              access_token: token_data['access_token']
            }
          else
            render json: { error: 'Failed to get access token from Spotify' }, status: :bad_request
          end
        else
          render json: { error: 'No authorization code received' }, status: :bad_request
        end
      end

      # Search for tracks
      def search
        query = params[:query]
        limit = params[:limit] || 20

        if query.blank?
          render json: { error: 'Query parameter is required' }, status: :bad_request
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

      # Get featured playlists for discovery
      def featured
        limit = params[:limit] || 10
        
        service = SpotifyService.new(current_user.spotify_access_token)
        playlists = service.get_featured_playlists(limit)

        render json: {
          playlists: playlists,
          total: playlists.size
        }
      end

      # Get new releases
      def new_releases
        limit = params[:limit] || 20
        
        service = SpotifyService.new(current_user.spotify_access_token)
        releases = service.get_new_releases(limit)

        render json: {
          releases: releases,
          total: releases.size
        }
      end

      # Get recommendations
      def recommendations
        seed_tracks = params[:seed_tracks] || []
        limit = params[:limit] || 20

        if seed_tracks.blank?
          render json: { error: 'Seed tracks are required for recommendations' }, status: :bad_request
          return
        end

        service = SpotifyService.new(current_user.spotify_access_token)
        recommendations = service.get_recommendations(seed_tracks, limit)

        render json: {
          recommendations: recommendations,
          total: recommendations.size
        }
      end

      # Get user's Spotify profile
      def profile
        service = SpotifyService.new(current_user.spotify_access_token)
        profile = service.get_user_profile

        if profile
          render json: { profile: profile }
        else
          render json: { error: 'Failed to get Spotify profile' }, status: :bad_request
        end
      end

      # Disconnect Spotify
      def disconnect
        current_user.update(
          spotify_access_token: nil,
          spotify_refresh_token: nil,
          spotify_token_expires_at: nil
        )

        render json: { message: 'Spotify disconnected successfully' }
      end
    end
  end
end