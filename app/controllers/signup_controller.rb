class SignupController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      payload = {user_id: user.id}
      session = JWTSession::Session.new(payload: payload, refresh_by_access_allowed: true)
    end

  end #end of create

  private #private methods

    def user_params
      params.permit(:username, :email, :password, :password_confirmation)
  end
end
