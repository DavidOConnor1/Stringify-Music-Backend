require 'httparty'


  module Music
    class ItunesService
      include HTTParty
      base_uri 'https://itunes.apple.com'
      
      DEFAULT_TIMEOUT = 10

      def search_tracks(query, limit = 20)
        begin
          response = self.class.get('/search', {
            query: {
              term: query,
              media: 'music',
              entity: 'song',
              limit: limit
            },
            timeout: DEFAULT_TIMEOUT
          })
          
          log_api_response(response)
          
          if response.success?
            cleaned_body = response.body.strip
            data = JSON.parse(cleaned_body)
            
            if data && data['results'].is_a?(Array)
              format_tracks(data['results'])
            else
              log_unexpected_format(data)
              []
            end
          else
            log_api_failure(response)
            []
          end
        rescue => e
          log_api_error(e)
          []
        end
      end

      def get_artist_tracks(artist_id, limit = 10)
        search_tracks(artist_id, limit)
      end

      def get_new_releases(limit = 12)
        search_tracks("2024", limit)
      end

      def get_artist_details(artist_id)
        response = self.class.get("/lookup", {
          query: { id: artist_id }
        })

        if response.success?
          response.parsed_response
        else 
          { error: "Failed to fetch artist details" }
        end 
      end

      private

      def format_tracks(tracks_data)
        tracks_data.map do |track|
          {
            id: track['trackId'],
            title: track['trackName'],
            artist: track['artistName'],
            album: track['collectionName'],
            album_image: track['artworkUrl100']&.gsub('100x100', '300x300'),
            duration_ms: track['trackTimeMillis'],
            preview_url: track['previewUrl'],
            external_url: track['trackViewUrl'],
            genre: track['primaryGenreName'],
            release_date: track['releaseDate'],
            price: track['trackPrice'],
            explicit: track['trackExplicitness'] == 'explicit'
          }
        end
      end

      def log_api_response(response)
        puts "=== ITUNES API RESPONSE ==="
        puts "Status: #{response.code}"
        puts "Body preview: #{response.body.first(200)}..."
      end

      def log_unexpected_format(data)
        puts "Unexpected response format: #{data.inspect}"
      end

      def log_api_failure(response)
        puts "API request failed: #{response.code} - #{response.message}"
      end

      def log_api_error(error)
        puts "ITunes API Error: #{error.message}"
        puts error.backtrace.first(5) if error.backtrace
      end
    end
  end
