require 'httparty'

class ItunesService
  include HTTParty
  base_uri 'https://itunes.apple.com'

  def search_tracks(query, limit = 20)
    begin
      response = self.class.get('/search', {
        query: {
          term: query,
          media: 'music',
          entity: 'song',
          limit: limit
        },
        timeout: 10 # Add timeout to prevent hanging
      })
      
      puts "=== ITUNES API RESPONSE ==="
      puts "Status: #{response.code}"
      puts "Body: #{response.body.first(200)}..." # First 200 chars
      
      if response.success?
        data = response.parsed_response
        if data && data['results'].is_a?(Array)
          format_tracks(data['results'])
        else
          puts "Unexpected response format: #{data.inspect}"
          []
        end
      else
        puts "API request failed: #{response.code} - #{response.message}"
        []
      end
    rescue => e
      puts "ITunes API Error: #{e.message}"
      []
    end
  end

  private

  def format_tracks(tracks)
    return [] unless tracks.is_a?(Array)
    
    tracks.map do |track|
      next unless track.is_a?(Hash) # Skip if track is not a hash
      
      {
        id: track['trackId'],
        title: track['trackName'] || 'Unknown Title',
        artist: track['artistName'] || 'Unknown Artist',
        album: track['collectionName'] || 'Unknown Album',
        preview_url: track['previewUrl'],
        duration: track['trackTimeMillis'],
        external_url: track['trackViewUrl'],
        album_image: track['artworkUrl100']&.gsub('100x100', '300x300'),
        price: track['trackPrice'],
        genre: track['primaryGenreName'],
        external: true,
        source: 'itunes'
      }
    end.compact # Remove any nil entries
  end
end