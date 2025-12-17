
  module Music
    class MusicLibrary
      def initialize
        @featured_artists_service = FeaturedArtists.new
        @featured_songs_service = FeaturedSongs.new
        @itunes_service = ItunesService.new
      end

      def get_featured_artists
        @featured_artists_service.fetch_artists
      end

      def get_featured_songs
        @featured_songs_service.fetch_songs
      end

      def search_songs(query, limit = 20)
        @itunes_service.search_tracks(query, limit)
      end

      def get_new_releases
        @itunes_service.get_new_releases
      end
    end
  end
