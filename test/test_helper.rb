ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

require "rails/test_help"
require "minitest/rails/capybara"
require "mocha/mini_test"
require "shoulda/context"

require "support/minitest_reporters"
require "support/poltergeist"
require "support/subdomains"
require "support/database_cleaner"
require "support/omniauth"

require "shared/test_helpers/slack/identity"

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
