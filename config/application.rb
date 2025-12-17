require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StringifyMusicBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # IMPORTANT: Properly configure autoload for app/library
    # Remove any conflicting autoload_paths lines you added
    config.autoload_paths << Rails.root.join('app/library')
    
    # Or use this to be more specific:
    # config.autoload_paths += Dir[Rails.root.join('app/library/**/')]
    
    # Also add to eager_load_paths for production
    config.eager_load_paths << Rails.root.join('app/library')
    
    # If you still have issues, disable autoloading for library temporarily
    # config.autoload_once_paths << Rails.root.join('app/library')

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end