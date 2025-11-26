# app/services/itunes_service.rb
require 'httparty'

class ItunesService
  include HTTParty
  base_uri 'https://itunes.apple.com'

  def search_tracks(query, limit = 20)
    response = self.class.get('/search', {
      query: {
        term: query,
        media: 'music',
        entity: 'song',
        limit: limit
      }
    })
    
    if response.success?
      format_tracks(response.parsed_response['results'])
    else
      []
    end
  end

  private

  def format_tracks(tracks)
    tracks.map do |track|
      {
        id: track['trackId'],
        title: track['trackName'],
        artist: track['artistName'],
        album: track['collectionName'],
        preview_url: track['previewUrl'],
        duration: track['trackTimeMillis'],
        external_url: track['trackViewUrl'],
        album_image: track['artworkUrl100']&.gsub('100x100', '300x300'),
        price: track['trackPrice'],
        genre: track['primaryGenreName'],
        external: true,
        source: 'itunes'
      }
    end
  end
end