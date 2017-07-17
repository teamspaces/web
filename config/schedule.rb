# Run the following in development to test schedules:
# bundle exec clockwork ./config/schedule.rb

require "rubygems"
require "clockwork"
require File.expand_path("../boot", __FILE__)
require File.expand_path("../environment", __FILE__)

module Clockwork
  configure do |config|
    config[:tz] = "Europe/Stockholm"
  end

  # Make sure we have fresh information on how to rank
  # results
  every 1.hour, "Page.reindex" do
    Page.reindex
  end
end
