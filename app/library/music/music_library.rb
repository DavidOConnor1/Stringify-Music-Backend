module Library
    module Music
        class MusicLibrary

            def intialize
                @featured_artist_service = FeaturedArtists.new
                