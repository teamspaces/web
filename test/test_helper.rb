ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

require "rails/test_help"
require "minitest/reporters"
require "minitest/rails/capybara"
require "mocha/mini_test"
require "shoulda/context"
require "capybara/poltergeist"
require "database_cleaner"
require "shared/test_helpers/slack/identity"

Minitest::Reporters.use!

Capybara.configure do |config|
  config.default_driver = :poltergeist
  config.javascript_driver = :poltergeist
  config.app_host = "http://#{ENV["DEFAULT_SUBDOMAIN"]}.lvh.me"
  config.default_host = "http://#{ENV["DEFAULT_SUBDOMAIN"]}.lvh.me"
  config.always_include_port = true
  config.default_max_wait_time = 10
end

DatabaseCleaner[:active_record].strategy = :truncation
DatabaseCleaner[:mongoid].strategy = :truncation

class ActiveSupport::TestCase
  fixtures :all
end

class ActiveSupport::IntegrationTest
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Assertions
  include Devise::Test::IntegrationHelpers

  def setup
    Capybara.reset!
    DatabaseCleaner.start
  end

  def teardown
    Capybara.reset!
    Capybara.use_default_driver
    DatabaseCleaner.clean
  end
end

# Fake OmniAuth requests
# https://github.com/intridea/omniauth/wiki/Integration-Testing
OmniAuth.config.test_mode = true
