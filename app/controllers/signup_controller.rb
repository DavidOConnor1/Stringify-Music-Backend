class SignupController < ApplicationController
  skip_before_action :verify_authenticity_token 
  
  def create
    puts "=== SIGNUP PARAMS ==="
    puts params.inspect
    puts "====================="
    
    user = User.new(user_params)

    if user.save
      puts "User created successfully: #{user.id}"
      payload = { user_id: user.id }
      session = JWTSession::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)
      
      render json: { csrf: tokens[:csrf] }
    else
      puts "User creation failed: #{user.errors.full_messages}"
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end