ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  fixtures :all
end

class ActiveSupport::IntegrationTest
end

# Make OmniAuth fake requests
# https://github.com/intridea/omniauth/wiki/Integration-Testing
OmniAuth.config.test_mode = true
