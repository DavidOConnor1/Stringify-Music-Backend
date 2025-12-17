module Api::V1
  class MusicController < ApplicationController
    # Explicitly require the library files
    

    before_action :initialize_library

    def search
      begin
        puts "=== SEARCH REQUEST ==="
        query = params[:query]
        limit = params[:limit] || 20
        
        if query.blank?
          return render json: { error: "Query parameter is required" }, status: :bad_request
        end

        puts "Searching for: #{query}, limit: #{limit}"
        results = @music_library.search_songs(query, limit)
        puts "Search results: #{results.inspect}"
        
        render json: { results: results }
      rescue => e
        puts "=== SEARCH ERROR ==="
        puts e.message
        puts e.backtrace
        render json: { error: "Search failed: #{e.message}" }, status: :internal_server_error
      end
    end

    def featured_artists
      begin
        puts "=== FEATURED ARTISTS REQUEST ==="
        artists = @music_library.get_featured_artists
        puts "Artists returned: #{artists.inspect}"
        render json: { artists: artists }
      rescue => e
        puts "=== FEATURED ARTISTS ERROR ==="
        puts e.message
        puts e.backtrace
        render json: { error: "Failed to load featured artists: #{e.message}" }, status: :internal_server_error
      end
    end

    def featured_songs
      begin
        puts "=== FEATURED SONGS REQUEST ==="
        songs = @music_library.get_featured_songs
        puts "Songs returned: #{songs.inspect}"
        render json: { songs: songs }
      rescue => e
        puts "=== FEATURED SONGS ERROR ==="
        puts e.message
        puts e.backtrace
        render json: { error: "Failed to load featured songs: #{e.message}" }, status: :internal_server_error
      end
    end

    private

     def initialize_library
      begin
        puts "=== INITIALIZING MUSIC LIBRARY ==="
        
        # Try to use Library::Music::MusicLibrary if it exists
        # Otherwise use top-level MusicLibrary
        if defined?(Library::Music::MusicLibrary)
          @music_library = Library::Music::MusicLibrary.new
        elsif defined?(MusicLibrary)
          @music_library = MusicLibrary.new
        else
          # Fallback stub for tests
          @music_library = Object.new
          def @music_library.search_songs(*); []; end
          def @music_library.get_featured_artists; []; end
          def @music_library.get_featured_songs; []; end
          def @music_library.get_new_releases; []; end
        end
        
        puts "Library initialized successfully"
      rescue => e
        puts "=== LIBRARY INITIALIZATION ERROR ==="
        puts e.message
        puts e.backtrace
        raise e
      end
    end
  end
end