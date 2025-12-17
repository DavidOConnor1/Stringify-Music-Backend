module Api
  module V1
    class ArtistsController < ApplicationController
      before_action :authorize_access_request!, except: [:show, :index]
      before_action :set_artist, only: %i[ show update destroy ]

      # GET /artists
      def index
        @artists = Artist.all
        render json: @artists
      end

      # GET /artists/1
      def show
        render json: @artist
      end

      # POST /artists
      def create
        @artist = current_user.artists.build(artist_params) # Associate with current user

        if @artist.save
          render json: @artist, status: :created 
        else
          render json: @artist.errors, status: :unprocessable_entity 
        end
      end

      # PATCH/PUT /artists/1
      def update
        if @artist.update(artist_params)
          render json: @artist
        else
          render json: @artist.errors, status: :unprocessable_entity 
        end
      end

      # DELETE /artists/1
      def destroy
        @artist.destroy!
        head :no_content 
      end

      private

      def set_artist
        @artist = Artist.find(params[:id])
      end

      def artist_params
        # Handles both nested and flat parameters
        if params[:artist]
          params.require(:artist).permit(:name)
        else
          params.permit(:name)
        end
      end
    end
  end
end