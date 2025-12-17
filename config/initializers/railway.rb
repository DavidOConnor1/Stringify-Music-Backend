# config/initializers/railway.rb
if ENV['RAILWAY_STATIC_URL']
  # Configure for Railway
  Rails.application.routes.default_url_options = {
    host: ENV['RAILWAY_STATIC_URL'],
    protocol: 'https'
  }
  
  # Log Railway environment info
  Rails.logger.info "Running on Railway: #{ENV['RAILWAY_STATIC_URL']}"
end