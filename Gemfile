ruby "2.3.1"
source "https://rubygems.org"

gem "rails", "~> 5.0.0"
gem "pg"
gem "mongoid"
gem "puma"
gem "therubyracer", platforms: :ruby

gem "envied"
gem "lograge"
gem "bcrypt"
gem "jbuilder"
gem "jquery-rails"
gem "sass-rails"
gem "uglifier"
gem "turbolinks"

gem "inflorm"
gem "devise"
gem "omniauth-slack"
gem "httparty"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

group :test do
  gem "minitest-rails"
  gem "minitest-rails-capybara"
  gem "mocha"
  gem "shoulda-context"
end

group :development, :test do
  gem "byebug"
  gem "awesome_print"
end

group :development do
  gem "web-console"
  gem "listen"
  gem "spring"
end

group :production do
  gem "passenger"
  gem "rails_12factor"
end
