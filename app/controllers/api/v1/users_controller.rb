module Api
    module V1
        class UsersController < ApplicationController
            before_action :authorize_access_request!
            before_action :set_user, only: [:show, :update]

           
          def upgrade_to_artist
            artist_name = params[:artist_name]
  
            if artist_name.blank?
                render json: { error: "Artist name is required" }, status: :unprocessable_entity
                return
            end
  
            # Create artist record and update user
            artist = Artist.new(name: artist_name, user_id: current_user.id)
  
             if artist.save && current_user.update(is_artist: true, artist_name: artist_name)
                render json: { 
                    message: "You are now an artist!", 
                    user: current_user,
                    artist: artist
                    }
            else
                errors = [artist.errors.full_messages, current_user.errors.full_messages].flatten
                render json: { error: errors.join(', ') }, status: :unprocessable_entity
            end
        end
           
            #GET 
            def show
                render json: @user, except: [:password_digest]
            end

            #Patch/PUT

            def update
                update_params = user_params
  
                # Only validate password if it's being changed
                if update_params[:password].blank?
                    update_params.delete(:password)
                    update_params.delete(:password_confirmation)
                end
  
                if current_user.update(update_params)
                    render json: current_user, except: [:password_digest]
                else
                    render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
                end
            end


            private

            def set_user
                @user = current_user
            end

            def user_params
                params.require(:user).permit(:username, :email, :password, :password_confirmation, :artist_name)
            end
        end
    end
end