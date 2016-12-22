ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails/capybara"
require "mocha/mini_test"
require "shoulda/context"
require "capybara/poltergeist"
require "shared/test_helpers/slack/identity"

class ActiveSupport::TestCase
  fixtures :all
end

class ActiveSupport::IntegrationTest
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include Capybara::DSL
  include Capybara::Assertions

  setup do
    Capybara.default_driver = :poltergeist
    Capybara.app_host = "http://#{ENV["DEFAULT_SUBDOMAIN"]}.lvh.me"
    Capybara.default_host = "#{ENV["DEFAULT_SUBDOMAIN"]}.lvh.me"
    Capybara.always_include_port = true
  end

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.app_host = nil
    Capybara.default_host = "http://www.example.com"
    Capybara.use_default_driver
    Capybara.always_include_port = false
    Capybara.reset_sessions!
  end

  def sign_in_user
    user = users(:ulf)
    sign_in user
    user
  end

  def submit_form
    find('input[name="commit"]').click
  end
end


# Make OmniAuth fake requests
# https://github.com/intridea/omniauth/wiki/Integration-Testing
OmniAuth.config.test_mode = true
