
  module Music
    class FeaturedSongs
     
      def fetch_songs
        #Predefined Song list
        [
          {
            id: 1739659144,
            title: "WILDFLOWER",
            artist: "Billie Eilish",
            album: "HIT ME HARD AND SOFT",
            album_image: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/92/9f/69/929f69f1-9977-3a44-d674-11f70c852d1b/24UMGIM36186.rgb.jpg/300x300bb.jpg",
            duration_ms: 261467,
            preview_url: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview221/v4/30/35/10/303510ea-fe5b-39c7-26cc-d0e50698393f/mzaf_12539564791562071844.plus.aac.p.m4a",
            external_url: "https://music.apple.com/us/album/wildflower/1739659134?i=1739659144",
            genre: "Alternative",
            release_year: 2024,
            popularity: 95
          },
          {
            id: 1440899467,
            title: "ocean eyes",
            artist: "Billie Eilish",
            album: "dont smile at me",
            album_image: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/02/1d/30/021d3036-5503-3ed3-df00-882f2833a6ae/17UM1IM17026.rgb.jpg/300x300bb.jpg",
            duration_ms: 200379,
            preview_url: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/66/1f/6f/661f6fbf-cae2-5209-c12c-b9ae9bde9f56/mzaf_9388830456300374759.plus.aac.p.m4a",
            external_url: "https://music.apple.com/us/album/ocean-eyes/1440898929?i=1440899467",
            genre: "Alternative",
            release_year: 2016,
            popularity: 90
          },
          {
            id: 1724896212,
            title: "YEAH RIGHT",
            artist: "Joji",
            album: "BALLADS 1",
            album_image: "https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/7b/63/fd/7b63fdf0-31a7-ed7c-0449-ca3df4aec9dc/190296925382.jpg/300x300bb.jpg",
            duration_ms: 174358,
            preview_url: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/d5/72/a0/d572a03c-80f9-4a9e-f72b-a29e7d1e4e9d/mzaf_6087730496363625132.plus.aac.p.m4a",
            external_url: "https://music.apple.com/us/album/yeah-right/1724896193?i=1724896212",
            genre: "R&B/Soul",
            release_year: 2018,
            popularity: 88
          },
          {
            id: 1442245567,
            title: "Yeah Right",
            artist: "Vince Staples",
            album: "Big Fish Theory",
            album_image: "https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/cc/18/a1/cc18a183-be4f-9f5d-786f-af293d2edaf2/17UM1IM00779.rgb.jpg/300x300bb.jpg",
            duration_ms: 188952,
            preview_url: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/21/be/e8/21bee865-e27d-6a09-f61c-6a3bf903efad/mzaf_2310141146411236763.plus.aac.p.m4a",
            external_url: "https://music.apple.com/us/album/yeah-right/1442245025?i=1442245567",
            genre: "Hip-Hop/Rap",
            release_year: 2017,
            popularity: 82
          }
        ]
      end

      def get_trending_songs
        fetch_songs.sort_by { |song| -song[:popularity] }
      end

      def get_songs_by_genre(genre)
        fetch_songs.select { |song| song[:genre].downcase.include?(genre.downcase) }
      end
    end
  end
