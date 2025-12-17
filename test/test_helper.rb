ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Load support files
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  class IntegrationTest
    # Helper to generate authentication headers for JWT
    def auth_headers_for(user, additional_headers = {})
      # Encode the user ID in a JWT token
      payload = { user_id: user.id }
      secret = Rails.application.secret_key_base
      
      # Generate token (adjust algorithm if needed)
      token = JWT.encode(payload, secret, 'HS256')
      
      # Return headers
      {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }.merge(additional_headers)
    end
    
    # Helper to parse JSON response
    def parsed_response
      JSON.parse(response.body)
    rescue JSON::ParserError
      response.body
    end
    
    # Helper to create a user and get auth headers in one step
    def create_user_and_auth_headers(attributes = {})
      default_attrs = {
        username: "testuser_#{SecureRandom.hex(4)}",
        email: "test_#{SecureRandom.hex(4)}@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
      
      user = User.create!(default_attrs.merge(attributes))
      [user, auth_headers_for(user)]
    end
    
    # Helper to login and get auth headers
    def login_and_get_auth_headers(email, password)
      post api_v1_login_url, params: { email: email, password: password }, as: :json
      token = parsed_response['token'] || parsed_response['access']
      
      {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end
    
    # Clean up JWTSessions cookies between tests
    setup do
      if defined?(JWTSessions) && JWTSessions.respond_to?(:access_cookie)
        cookies.delete(JWTSessions.access_cookie)
      end
    end
  end
end

# Configure shoulda-matchers if you're using them
if defined?(Shoulda::Matchers)
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :minitest
      with.library :rails
    end
  end
end

# Configure DatabaseCleaner if you're using it (alternative to transactional fixtures)
# require 'database_cleaner'
# DatabaseCleaner.strategy = :transaction

# Configure VCR for API testing if needed
# require 'vcr'
# require 'webmock/minitest'
# 
# VCR.configure do |config|
#   config.cassette_library_dir = "test/vcr_cassettes"
#   config.hook_into :webmock
#   config.ignore_localhost = true
#   config.default_cassette_options = { record: :new_episodes }
#   config.configure_rspec_metadata!
# end

# Configure Bullet for N+1 query detection in tests
# if ENV['BULLET']
#   require 'bullet'
#   Bullet.enable = true
#   Bullet.bullet_logger = true
#   Bullet.raise = true # raise an error if N+1 query occurs
# end

# Configure FactoryBot if you're using it (in addition to or instead of fixtures)
# require 'factory_bot'
# FactoryBot.find_definitions
# 
# class ActiveSupport::TestCase
#   include FactoryBot::Syntax::Methods
# end

# Configure simplecov for test coverage (run with COVERAGE=true)
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter '/test/'
    add_filter '/config/'
    add_filter '/vendor/'
    
    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Services', 'app/services'
    add_group 'Jobs', 'app/jobs'
    add_group 'Mailers', 'app/mailers'
  end
end

# Custom assertions
module CustomAssertions
  def assert_json_response(expected_status = :success)
    assert_response expected_status
    assert_equal 'application/json', response.content_type
  end
  
  def assert_valid_schema(data, schema_path)
    schema = JSON.parse(File.read(Rails.root.join(schema_path)))
    errors = JSON::Validator.fully_validate(schema, data)
    assert errors.empty?, "JSON schema validation failed: #{errors.join(', ')}"
  end
  
  def assert_includes_response(key, value = nil)
    json = parsed_response
    assert json.key?(key), "Expected response to include key '#{key}'"
    assert_equal value, json[key] if value
  end
  
  def refute_includes_response(key)
    json = parsed_response
    refute json.key?(key), "Expected response not to include key '#{key}'"
  end
end

# Include custom assertions in all tests
class ActiveSupport::TestCase
  include CustomAssertions
end

# Configure time helpers for freezing time in tests
class ActiveSupport::TestCase
  # Freeze time for a test
  def travel_to_time(time)
    travel_to(time) do
      yield
    end
  end
  
  # Freeze time to now
  def freeze_time
    travel_to(Time.current) do
      yield
    end
  end
end

# Monkey patch to silence noisy log output during tests
if ENV['SILENCE_LOGS']
  Rails.logger = Logger.new(nil)
  ActiveRecord::Base.logger = nil
end

# Configure mailer testing
class ActionDispatch::IntegrationTest
  # Helper to get the last email sent
  def last_email
    ActionMailer::Base.deliveries.last
  end
  
  # Clear emails between tests
  setup do
    ActionMailer::Base.deliveries.clear
  end
end

# Add support for testing file uploads if using Active Storage
if defined?(ActiveStorage)
  class ActionDispatch::IntegrationTest
    def fixture_file_upload(path, mime_type = nil)
      Rack::Test::UploadedFile.new(
        Rails.root.join('test/fixtures/files', path),
        mime_type
      )
    end
  end
end

# Configure for system tests if you have them
if defined?(Capybara)
  require 'capybara/rails'
  require 'capybara/minitest'
  
  class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
    
    def sign_in(user)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
    end
  end
end

# Minitest reporters for better test output
if ENV['REPORTERS'] || ENV['CI']
  require 'minitest/reporters'
  Minitest::Reporters.use!([
    Minitest::Reporters::DefaultReporter.new(color: true),
    # Minitest::Reporters::JUnitReporter.new, # For CI
    # Minitest::Reporters::ProgressReporter.new # Alternative
  ])
end

# Seed test data if needed
# ActiveRecord::FixtureSet.reset_cache
# fixtures_folder = File.join(Rails.root, 'test/fixtures')
# fixtures = Dir[File.join(fixtures_folder, '*.yml')].map { |f| File.basename(f, '.yml') }
# ActiveRecord::FixtureSet.create_fixtures(fixtures_folder, fixtures)