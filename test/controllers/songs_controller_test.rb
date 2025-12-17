require "test_helper"

module Api
  module V1
    class SongsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one) # Assuming you have users fixture
        @artist = artists(:one) # Assuming you have artists fixture
        @song = songs(:one)
        @auth_headers = auth_headers_for(@user)
      end

      # Public endpoint tests (no authentication required)
      test "should get public index without authentication" do
        get api_v1_songs_public_index_url, as: :json
        assert_response :success
        
        json_response = response.parsed_body
        assert json_response.is_a?(Array)
      end

      # Authenticated endpoint tests
      test "should get index with authentication" do
        get api_v1_songs_url, headers: @auth_headers, as: :json
        assert_response :success
        
        json_response = response.parsed_body
        assert json_response.is_a?(Array)
        # Verify the response includes artist and user data
        assert_not_nil json_response.first["artist"]
        assert_not_nil json_response.first["user"]
      end

      test "should not get index without authentication" do
        get api_v1_songs_url, as: :json
        assert_response :unauthorized
      end

      test "should create song with authentication" do
        assert_difference("@user.songs.count") do
          post api_v1_songs_url,
               params: { song: { title: "New Song", year: 2024, artist_id: @artist.id } },
               headers: @auth_headers,
               as: :json
        end

        assert_response :created
        assert_equal @user.id, Song.last.user_id
      end

      test "should create song with flat parameters" do
        assert_difference("@user.songs.count") do
          post api_v1_songs_url,
               params: { title: "Flat Param Song", year: 2024, artist_id: @artist.id },
               headers: @auth_headers,
               as: :json
        end

        assert_response :created
      end

      test "should not create song without authentication" do
        assert_no_difference("Song.count") do
          post api_v1_songs_url,
               params: { song: { title: "New Song", year: 2024, artist_id: @artist.id } },
               as: :json
        end

        assert_response :unauthorized
      end

      test "should not create song with invalid parameters" do
        assert_no_difference("@user.songs.count") do
          post api_v1_songs_url,
               params: { song: { title: "", year: "invalid", artist_id: nil } },
               headers: @auth_headers,
               as: :json
        end

        assert_response :unprocessable_entity
      end

      test "should show song with authentication" do
        get api_v1_song_url(@song), headers: @auth_headers, as: :json
        assert_response :success
      end

      test "should not show song without authentication" do
        get api_v1_song_url(@song), as: :json
        assert_response :unauthorized
      end

      test "should not show other user's song" do
        other_user = users(:two)
        other_song = songs(:two) # Assuming this belongs to user two
        
        get api_v1_song_url(other_song), headers: @auth_headers, as: :json
        assert_response :not_found
      end

      test "should update song with authentication" do
        patch api_v1_song_url(@song),
              params: { song: { title: "Updated Title", year: 2025 } },
              headers: @auth_headers,
              as: :json
        
        assert_response :success
        @song.reload
        assert_equal "Updated Title", @song.title
        assert_equal 2025, @song.year
      end

      test "should update song with flat parameters" do
        patch api_v1_song_url(@song),
              params: { title: "Flat Update", year: 2023 },
              headers: @auth_headers,
              as: :json
        
        assert_response :success
        @song.reload
        assert_equal "Flat Update", @song.title
      end

      test "should not update song without authentication" do
        original_title = @song.title
        
        patch api_v1_song_url(@song),
              params: { song: { title: "Updated Title" } },
              as: :json
        
        assert_response :unauthorized
        @song.reload
        assert_equal original_title, @song.title
      end

      test "should not update other user's song" do
        other_user = users(:two)
        other_song = songs(:two)
        original_title = other_song.title
        
        patch api_v1_song_url(other_song),
              params: { song: { title: "Hacked Title" } },
              headers: @auth_headers,
              as: :json
        
        assert_response :not_found
        other_song.reload
        assert_equal original_title, other_song.title
      end

      test "should destroy song with authentication" do
        assert_difference("@user.songs.count", -1) do
          delete api_v1_song_url(@song),
                 headers: @auth_headers,
                 as: :json
        end

        assert_response :no_content
      end

      test "should not destroy song without authentication" do
        assert_no_difference("Song.count") do
          delete api_v1_song_url(@song), as: :json
        end

        assert_response :unauthorized
      end

      test "should not destroy other user's song" do
        other_user = users(:two)
        other_song = songs(:two)
        
        assert_no_difference("Song.count") do
          delete api_v1_song_url(other_song),
                 headers: @auth_headers,
                 as: :json
        end

        assert_response :not_found
      end

      test "public index should only show public songs when is_public column exists" do
        # First, ensure we have some songs
        @user.songs.create!(title: "Public Song", year: 2024, artist_id: @artist.id, is_public: true)
        @user.songs.create!(title: "Private Song", year: 2024, artist_id: @artist.id, is_public: false)
        
        get api_v1_songs_public_index_url, as: :json
        assert_response :success
        
        json_response = response.parsed_body
        
        # Check if songs have is_public field
        if json_response.any?
          song = json_response.first
          if song.key?("is_public")
            # If is_public field exists, all returned songs should be public
            assert json_response.all? { |s| s["is_public"] == true }
          end
        end
      end

      private

      # Helper method to generate authentication headers
      def auth_headers_for(user)
        token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
        { 'Authorization': "Bearer #{token}" }
      end
    end
  end
end