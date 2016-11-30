ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'mocha/mini_test'
require 'shoulda/context'

require "shared/test_helpers/slack/identity"

class ActiveSupport::TestCase
  fixtures :all
end

class ActiveSupport::IntegrationTest
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def sign_in_user
    user = users(:ulf)
    sign_in user
    user
  end
end


# Make OmniAuth fake requests
# https://github.com/intridea/omniauth/wiki/Integration-Testing
OmniAuth.config.test_mode = true
