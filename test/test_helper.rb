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

require "test_helpers/subdomain_helper"

class ActiveSupport::TestCase
  fixtures :all
end

class Capybara::Rails::TestCase

  setup do
    Capybara.reset!
    DatabaseCleaner.start
  end

  teardown do
    Capybara.reset!
    Capybara.use_default_driver
    DatabaseCleaner.clean
  end
end

class ActionDispatch::IntegrationTest
  #include Capybara::DSL
  #include Capybara::Assertions
  include Devise::Test::IntegrationHelpers


  #setup do
  #  Capybara.reset!
  #  DatabaseCleaner.start
  #end

  #teardown do
  #  Capybara.reset!
  #  Capybara.use_default_driver
  #  DatabaseCleaner.clean
  #end
end
