module Api::V1
    class PlaylistsController < ApplicationController
        before_action :authenticate_user!, except: [:index, :show]
        before_action :set_playlist, only: [:show, :update, :destroy, :add_song, :remove_song]

        # Will serve as GET

        def index
            if params[:user_id]
                #Get playlist for specific user
                user_playlists = Playlist.by_user(params[:user_id])
                playlists = current_user && current_user.id == params[:user_id].to_i ?

                user_playlists : user_playlists.public_playlists

            else

                #get all public playlists or current user playlist

                playlist = current_user ? Playlist.where("user_id = ? or is_public = ?", current_user.id, true) : Playlist.public_playlists
            end

            render json: playlists.includes(:user).order(created_at: :desc)
        end

        #Retrive the playlist via id

        def show
            #checks if the playlist is accessible

            unless @playlist.is_public || (current_user && @playlist.user_id == current_user.id)
                return render json: {error: "playlist not found or access denied"}, status: :not_found
            end

            render json: @playlist, include: [:user, songs: {include : : artist}]
        end

        