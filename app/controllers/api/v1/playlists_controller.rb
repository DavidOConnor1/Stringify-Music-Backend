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

        def create 
            if @playlist.save
                render json: @playlist, status: :created
            else 
                render json: {errors: @playlist.errors.full_messages}, status: :unprocessable_entity
            end
        end

        #Patch/Put

        def update
            #Checks ownership
            unless @playlist.user_id == current_user.id
                return render json: {error: "This may not be your playlist to update"}, status: :forbidden
            end

            if @playlist.update(playlist_params)
                render json: @playlist
            else
                render json: {errors: @playlist.errors.full_messages}, status: :unprocessable_entity
            end
        end

        #delete
        def destroy
            #checks ownership of playlist
            unless @playlist.user_id == current_user.id
                return render json: {error: "You are not the owner to remove this playlist"}, status: :forbidden
            end

            @playlist.destroy
            render json: {message :"Playlist has been deleted successfully"}
        end

        def add_song
            #clarify ownership
            unless @playlist.user_id == current_user.id
                return render json: {error: "Cannot add music to this playlist because you are not the owner."},
                status: :forbidden
            end

            song = Song.find_by(id: params[:song_id])
            unless song
                return render json: {error: "Song not found"}, status: not_found
                end

                #checks if song is already in playlist
                if @playlist.songs.exists?(song.id)
                    return render json: {error: "song already in playlist"},
                    status: :unprocessable_entity
                end

                playlist_song = @playlist.playlist_song.build(song: song)

                if playlist_song.save
                    render json: {
                        message: "song added to playlist",
                        playlist: @playlist.reload,
                        songs_count: @playlist.songs_count
                    }
                else
                    render json: {error: playlist_song.errors.full_messages},
                    status: :unprocessable_entity
                end
            end

            def remove_song
                #checks ownership
                unless @playlist.user_id == current_user.id
                    return render json: {error: "Cannot modify this playlist"},
                    status: :forbidden
                end

            