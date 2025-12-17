require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # IMPORTANT: Disable for Railway/Render (they handle SSL at load balancer)
  config.assume_ssl = false  # Changed from true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # IMPORTANT: Disable for Railway/Render (they handle SSL)
  config.force_ssl = false  # Changed from true

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # IMPORTANT: Simplify cache store for Railway (solid_cache requires Redis)
  # Use memory store instead for simplicity
  config.cache_store = :memory_store  # Changed from :solid_cache_store

  # IMPORTANT: Simplify job queue for Railway (solid_queue requires database setup)
  config.active_job.queue_adapter = :inline  # Changed from :solid_queue
  # Remove or comment out: config.solid_queue.connects_to = { database: { writing: :queue } }

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Set host to be used by links generated in mailer templates.
  # IMPORTANT: Update with your actual domain
  config.action_mailer.default_url_options = { host: ENV['APP_DOMAIN'] || 'localhost:3000' }

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # IMPORTANT: Allow all hosts for Railway/Render
  config.hosts.clear  # Allow all hosts
  
  # Or be more specific:
  # config.hosts = [
  #   ENV['RAILWAY_STATIC_URL']&.sub('https://', '')&.sub('http://', ''),  # Railway
  #   ENV['RENDER_EXTERNAL_HOSTNAME'],  # Render
  #   "localhost"  # Local development
  # ]

  # IMPORTANT: Enable serving static files
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || ENV['RENDER'].present?

  # IMPORTANT: CORS configuration for your Vue frontend
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins ENV['FRONTEND_URL'] || 'http://localhost:5173'  # Your Vue dev server
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
    end
  end
end