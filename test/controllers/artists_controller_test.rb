require "test_helper"

module Api
  module V1
    class ArtistsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one) # Assuming you have a users fixture
        @artist = artists(:one)
        @auth_headers = auth_headers_for(@user) # You'll need to implement this helper
      end

      test "should get index without authentication" do
        get api_v1_artists_url, as: :json
        assert_response :success
      end

      test "should show artist without authentication" do
        get api_v1_artist_url(@artist), as: :json
        assert_response :success
      end

      test "should create artist with authentication" do
        assert_difference("Artist.count") do
          post api_v1_artists_url,
               params: { artist: { name: "New Artist" } },
               headers: @auth_headers,
               as: :json
        end

        assert_response :created
        assert_equal @user.id, Artist.last.user_id
      end

      test "should not create artist without authentication" do
        assert_no_difference("Artist.count") do
          post api_v1_artists_url,
               params: { artist: { name: "New Artist" } },
               as: :json
        end

        assert_response :unauthorized
      end

      test "should update artist with authentication" do
        patch api_v1_artist_url(@artist),
              params: { artist: { name: "Updated Artist" } },
              headers: @auth_headers,
              as: :json
        
        assert_response :success
        @artist.reload
        assert_equal "Updated Artist", @artist.name
      end

      test "should not update artist without authentication" do
        patch api_v1_artist_url(@artist),
              params: { artist: { name: "Updated Artist" } },
              as: :json
        
        assert_response :unauthorized
      end

      test "should destroy artist with authentication" do
        assert_difference("Artist.count", -1) do
          delete api_v1_artist_url(@artist),
                 headers: @auth_headers,
                 as: :json
        end

        assert_response :no_content
      end

      test "should not destroy artist without authentication" do
        assert_no_difference("Artist.count") do
          delete api_v1_artist_url(@artist), as: :json
        end

        assert_response :unauthorized
      end

      test "should accept nested and flat parameters" do
        # Test with nested parameters
        post api_v1_artists_url,
             params: { artist: { name: "Nested Params Artist" } },
             headers: @auth_headers,
             as: :json
        
        assert_response :created

        # Test with flat parameters
        post api_v1_artists_url,
             params: { name: "Flat Params Artist" },
             headers: @auth_headers,
             as: :json
        
        assert_response :created
      end

      private

      # Helper method to generate authentication headers
      # Adjust based on your authentication implementation
      def auth_headers_for(user)
        token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
        { 'Authorization': "Bearer #{token}" }
      end
    end
  end
end