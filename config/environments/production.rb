require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = false  # Disabled for now
  config.consider_all_requests_local = false
  config.public_file_server.enabled = true
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }
  config.assume_ssl = false
  config.force_ssl = false
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.active_support.report_deprecations = false
  config.cache_store = :memory_store
  config.active_job.queue_adapter = :inline
  config.action_mailer.default_url_options = { host: ENV['APP_DOMAIN'] || 'localhost:3000' }
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]
  config.hosts.clear
end
config.eager_load = false
