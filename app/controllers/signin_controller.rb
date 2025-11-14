class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    # Handle both nested and flat parameters
    email = params[:email] || (params[:signin] && params[:signin][:email])
    password = params[:password] || (params[:signin] && params[:signin][:password])
    
    user = User.find_by(email: email)

    if user && user.authenticate(password)
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      
      response.set_cookie(JWTSessions.access_cookie,
                         value: tokens[:access],
                         httponly: true,
                         secure: Rails.env.production?)

      render json: { csrf: tokens[:csrf] }
    else
      render json: { error: 'Invalid email/password combination' }, status: :unauthorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end
end