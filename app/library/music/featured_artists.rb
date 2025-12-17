
    module Music
        class FeaturedArtists 
          def fetch_artists
                #A predefined list of artists
                [
                     {
            id: 1065981054,
            name: "Billie Eilish",
            genre: "Alternative",
            description: "Grammy-winning artist known for unique vocal style and atmospheric production",
            artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/92/9f/69/929f69f1-9977-3a44-d674-11f70c852d1b/24UMGIM36186.rgb.jpg/300x300bb.jpg",
            popularity: 95
          },
          {
            id: 3296287,
            name: "Beyoncé",
            genre: "R&B/Pop",
            description: "Iconic performer with powerful vocals and groundbreaking visual albums",
            artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/3a/84/8c/3a848c5c-6e33-4c69-7b5b-7e49f26c7c36/196589486069.jpg/300x300bb.jpg",
            popularity: 98
          },
          {
            id: 64387566,
            name: "Taylor Swift",
            genre: "Pop/Country",
            description: "Storytelling songwriter who reinvented herself across multiple genres",
            artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/9c/91/83/9c918303-e0a4-30d0-6e51-9993a635b4e7/196589486069.jpg/300x300bb.jpg",
            popularity: 99
          },
          {
            id: 5468295,
            name: "Ed Sheeran",
            genre: "Pop/Folk",
            description: "Singer-songwriter known for acoustic guitar and heartfelt lyrics",
            artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/83/71/0c/83710c28-78e2-7e3f-0f32-43c79ff74b36/190296074307.jpg/300x300bb.jpg",
            popularity: 92
          },
          {
            id: 471744,
            name: "Coldplay",
            genre: "Alternative Rock",
            description: "British band known for anthemic songs and atmospheric soundscapes",
            artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/9f/7f/6f/9f7f6f6f-6e6e-6f6f-6e6e-6f6f6f6f6f6f/190296074307.jpg/300x300bb.jpg",
            popularity: 90
          },
          {
            id: 1258279972,
            name: "Joji",
            genre: "R&B/Lo-fi",
            description: "Former internet personality turned serious R&B artist",
            artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/7b/63/fd/7b63fdf0-31a7-ed7c-0449-ca3df4aec9dc/190296925382.jpg/300x300bb.jpg",
            popularity: 85
          }
                ]
            end

            def fetch_artists_details(artist_id)
                intunes_service = ItunesService.new
                intunes_service.get_artists_details(artist_id)
            end
        end
    end