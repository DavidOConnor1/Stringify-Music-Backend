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