module Api::V1
  class MusicController < ApplicationController
    def search
      begin
        query = params[:query]
        limit = params[:limit] || 20
        
        if query.blank?
          return render json: { error: "Query parameter is required" }, status: :bad_request
        end

        # iTunes API call
        response = HTTParty.get("https://itunes.apple.com/search", {
          query: {
            term: query,
            media: "music",
            entity: "song",
            limit: limit
          }
        })

        if response.success?
          data = JSON.parse(response.body)
          itunes_results = data['results'] || []
          
          # Transform to match frontend expectations
          songs = itunes_results.map do |itunes_song|
            {
              id: itunes_song['trackId'],
              title: itunes_song['trackName'],
              artist: itunes_song['artistName'],
              album: itunes_song['collectionName'],
              album_image: itunes_song['artworkUrl100'],  # Frontend expects album_image
              duration_ms: itunes_song['trackTimeMillis'], # Frontend expects duration_ms
              preview_url: itunes_song['previewUrl'],
              external_url: itunes_song['trackViewUrl']   # Add external_url for "View" button
            }
          end

          # Return in the format frontend expects
          render json: {
            results: songs  # Frontend looks for response.data.results
          }
        else
          render json: {
            error: "iTunes API request failed"
          }, status: :unprocessable_entity
        end

      rescue => e
        puts "=== MUSIC SEARCH ERROR ==="
        puts e.message
        puts e.backtrace
        
        render json: {
          error: "Internal server error: #{e.message}"
        }, status: :internal_server_error
      end
    end
  end
end