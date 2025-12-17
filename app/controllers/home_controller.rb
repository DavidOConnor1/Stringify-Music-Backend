class HomeController < ApplicationController
    def index
        @artist = Artist.all
        render json: @artist
    end

     def up
    # Check database connection
    ActiveRecord::Base.connection.execute('SELECT 1')
    
    # Check Redis if you're using it
    
    
    render json: { 
      status: 'ok', 
      timestamp: Time.current,
      rails_env: Rails.env,
      database: ActiveRecord::Base.connection.current_database
    }
  rescue => e
    render json: { 
      status: 'error', 
      error: e.message,
      timestamp: Time.current 
    }, status: 500
  end
end