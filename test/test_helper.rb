require File.expand_path("../../config/environment", __FILE__)

require "rails/test_help"
require "minitest/rails/capybara"
require "minitest/around/spec"
require "mocha/mini_test"
require "shoulda/context"

require "support/minitest_reporters"
require "support/poltergeist"
require "support/subdomains"
require "support/database_cleaner"
require "support/omniauth"
require "support/sidekiq"
require "support/webmock"

require "shared/test_helpers/slack/identity"

require "test_helpers/subdomain_helper"
require "test_helpers/invitation_cookie_mock"

class ActiveSupport::TestCase
  fixtures :all
  self.use_transactional_tests = false
end

class Capybara::Rails::TestCase
  before do
    Capybara.reset!
    DatabaseCleaner.start
  end

  after do
    Capybara.reset!
    Capybara.use_default_driver
    DatabaseCleaner.clean
  end

  # Saves a screenshot to the rails tmp folder.
  # Very useful when debugging. Call it before the offending line.
  #
  # Example:
  #     click_on "Sign In"
  #     screenshot
  #     click_on "This non-existing link"
  #
  def screenshot
    name = Time.now.getutc
    path = Rails.root.join("tmp/#{name}.png")
    save_screenshot(path)
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def sign_in(user)
    ApplicationController.any_instance.stubs(:logged_in?).returns(true)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    session_mock = Struct.new(:m) do
      def self.invalidate! #on sign out
        ApplicationController.any_instance.unstub(:logged_in?)
        ApplicationController.any_instance.unstub(:current_user)
      end
    end

    ApplicationController.any_instance.stubs(:auth_session).returns(session_mock)
  end

  before do
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end
end
