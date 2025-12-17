module Library
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
            artwork: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Billie_Eilish_at_Pukkelpop_Festival_-_18_AUGUST_2019_%2801%29_%28cropped%29.jpg/1019px-Billie_Eilish_at_Pukkelpop_Festival_-_18_AUGUST_2019_%2801%29_%28cropped%29.jpg",
            popularity: 95
          },
          {
            id: 3296287,
            name: "Beyoncé",
            genre: "R&B/Pop",
            description: "Iconic performer with powerful vocals and groundbreaking visual albums",
            artwork: "https://www.instyle.com/thmb/23RXwolcSX79DnZVXlmXUSHFCXU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/022124-beyonce-hair-lead-1ec978ae6fea422eabd3dd888b3c0e2a.jpg",
            popularity: 98
          },
          {
            id: 64387566,
            name: "Taylor Swift",
            genre: "Pop/Country",
            description: "Storytelling songwriter who reinvented herself across multiple genres",
            artwork: "https://resizing.flixster.com/4HgCb0ytu44FoxHmJRpE06HtexY=/218x280/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/GNLZZGG002C8FJK.jpg",
            popularity: 99
          },
          {
            id: 5468295,
            name: "Ed Sheeran",
            genre: "Pop/Folk",
            description: "Singer-songwriter known for acoustic guitar and heartfelt lyrics",
            artwork: "https://cdn.britannica.com/17/249617-050-4575AB4C/Ed-Sheeran-performs-Rockefeller-Plaza-Today-Show-New-York-2023.jpg",
            popularity: 92
          },
          {
            id: 471744,
            name: "Coldplay",
            genre: "Alternative Rock",
            description: "British band known for anthemic songs and atmospheric soundscapes",
            artwork: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/ColdplayWembley120925_%28cropped%29.jpg/1200px-ColdplayWembley120925_%28cropped%29.jpg",
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
                @itunes_service.get_artist_details(artist_id)
            end
        end
    end
end