module Api
  module V1

    class SongsController < ApplicationController
      before_action :set_song, only: %i[ show update destroy ]

      # GET /songs
      def index
        @songs = Song.all

        render json: @songs
      end

      # GET /songs/1
      def show
        render json: @song
      end

      # POST /songs
      def create
        @song = Song.new(song_params)

        if @song.save
          render json: @song, status: :created, location: @song
        else
          render json: @song.errors, status: :unprocessable_content
        end
      end

      # PATCH/PUT /songs/1
      def update
        if @song.update(song_params)
          render json: @song
        else
          render json: @song.errors, status: :unprocessable_content
        end
      end

      # DELETE /songs/1
      def destroy
        @song.destroy!
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_song
          @song = Song.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def song_params
          params.expect(song: [ :title, :year, :artist_id, :user_id ])
        end
    end
  end
end