module Api
    module V1
        class UsersController < ApplicationController
            before_action :authorize_access_request!
            before_action :set_user, only: [:show, :update]

           
           def upgrade_to_artist
            if current_user.update(is_artist: true)
                render json: {message: "You became an Artist!", user: current_user}
                else
                    render json: {error:"Upgraded Failed"}, status: :unprocessable_entity
                end
            end
           
            #GET 
            def show
                render json: @user, except: [:password_digest]
            end

            #Patch/PUT

            def update
                if @user.update(user_params)
                    render json: @user, except: [:password_digest]
                else
                    render json: { errors: @user.errors.full_message}, status: :unprocessable_entity
                end
            end

            private

            def set_user
                @user = current_user
            end

            def user_params
                params.require(:user).permit(:username, :email, :password, :password_confirmation)
            end
        end
    end
end