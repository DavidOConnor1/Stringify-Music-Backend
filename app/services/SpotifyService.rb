class SpotifyService
    include HTTParty
    base_uri 'https://api.spotify.com/v1'

    def intialize (access_token = nil)
        @access_token = access_token
        @headers = {
            'Authorization' => "Bearer #{access_token}",
            'Content-Type' => 'application/json'
        } if access_token
    end

    #Generate Spotify URL
    def auth_url
        params = {
            client_id: ENV['SPOTIFY_CLIENT_ID']
            response_type: 'code',
            redirect_uri: ENV ['SPOTIFY_REDIRECT_URI'],
            scope: 'user-read-private user-read-email streaming user-read-playback-state user-modify-playback-state',
            show_dialog: false
        }

        "https://accounts.spotify.com/authorize#{params.to_query}"
    end

    #exchange authorization code for access token
    def exchange_code_for_token(code)
        response = self.class.post('https://accounts.spotify.com/api/token', {
            body: {
                grant_type: 'authorization_code',
                code: code,
                redirect_uri: ENV['SPOTIFY_REDIRECT_URI'],
                client_id: ENV['SPOTIFY_CLIENT_ID'],
                client_secret: ENV['SPOTIFY_CLIENT_SECRET']
            },
            headers: {
                'Content-Type' => 'application/x-www-form-urlencoded'
            }
        })

        response.success? ? response.parsed_response : nil
    end

    #search for tracks
    def search_music(query, limit = 20)
        return [] unless @access_token

        response = self.class .get('/search', {
            headers: @headers,
            query: {
                q: query,
                type: 'track',
                market: 'US',
                limit: limit
            }
        })

        if response.success?
            format_tracks(response.parsed_response['tracks']['items'])
        else
            []
        end 
    end

    #Get featured playlists
    def get_feature_playlists(limit = 10)
        return [] unless @access_token

        response = self.class.get('/browse/featured-playlists', {
            headers: @headers,
            query: {
                limit: limit,
                country: 'US'
            }
        })

        if response.success?
            response.parsed_response['playlists']['items']
        else 
            []
        end 
    end

    #format songs

    def format_songs(songs)
        tracks.map do |song|
            {
                id: song['id'],
                title: song['name'],
                artist: song['artists'].first['name'],
                artists: song['artists'].map { |a| a['name'] },
                album: song['album']['name'],
                preview_url: song['preview_url'],
                duration_ms: song['duration_ms'],
                external_url: song['external_urls']['spotify'],
                album_image: song['album']['images'].first&.dig('url'),
                popularity: song['popularity'],
                external: true,
                source: 'spotify'
            }
        end
    end

    def format_albums(albums)
        track.map do |album|
            {
                id: album['id'],
                name: album['name'],
                artists: album['artists'].map {|a| a['name']},
                release_date: album['release_date'],
                total_songs: album['total_tracks'],
                image: album['images'].first&.dig('url'),
                external_url: album['external_urls']['spotify']
            }
        end
    end
end