module JwtHelper
  def generate_jwt_token(user_id, expiration = 24.hours.from_now)
    payload = {
      user_id: user_id,
      exp: expiration.to_i,
      jti: SecureRandom.uuid
    }
    
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end
  
  def decode_jwt_token(token)
    JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256').first
  rescue JWT::DecodeError
    nil
  end
end

class ActionDispatch::IntegrationTest
  include JwtHelper
end