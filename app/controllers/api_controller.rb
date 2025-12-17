class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def health
    render json: {
      status: 'ok',
      service: 'Stringify Music API',
      timestamp: Time.now.iso8601,
      environment: Rails.env
    }
  end
end
