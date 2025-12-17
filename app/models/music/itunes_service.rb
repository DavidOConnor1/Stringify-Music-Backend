module Music
  class ItunesService
    def search_tracks(query, limit = 20); []; end
    def get_artist_tracks(artist_id, limit = 10); []; end
    def get_new_releases(limit = 12); []; end
    def get_artist_details(artist_id); {}; end
  end
end
