module Api
  module V1
    class SongsController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_song, only: %i[ show update destroy ]

      # GET /songs
      def index
        @songs = current_user.songs.all

        render json: @songs
      end

      # GET /songs/1
      def show
        render json: @song
      end

      # POST /songs
      def create
  puts "=== SONG CREATE PARAMS ==="
  puts params.inspect
  puts "==========================="
  @song = current_user.songs.build(song_params)

  if @song.save
    render json: @song, status: :created
  else
    render json: @song.errors, status: :unprocessable_entity
  end
end

      # PATCH/PUT /songs/1
      def update
        if @song.update(song_params)
          render json: @song
        else
          render json: @song.errors, status: :unprocessable_entity
        end
      end

      # DELETE /songs/1
      def destroy
        @song.destroy!
        head :no_content
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_song
        @song = current_user.songs.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def song_params
        # Handle both nested (:song) and direct parameters
        if params[:song]
          params.require(:song).permit(:title, :year, :artist_id)
        else
          params.permit(:title, :year, :artist_id)
        end
      end
    end
  end
end