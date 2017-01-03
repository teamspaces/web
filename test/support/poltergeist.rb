require "capybara/poltergeist"

Capybara.configure do |config|
  config.default_driver = :poltergeist
  config.javascript_driver = :poltergeist
  config.default_max_wait_time = 3
end
