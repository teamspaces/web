ruby "2.3.1"
source "https://rubygems.org"

gem "rails", "~> 5.0.0.rc2"
gem "pg"
gem "puma"
gem "therubyracer", platforms: :ruby

gem "bcrypt"
gem "jbuilder"
gem "jquery-rails"
gem "sass-rails"
gem "uglifier"
gem "turbolinks"

gem "devise"
gem "omniauth"
gem "omniauth-slack"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

group :test do
  gem "minitest-rails", "~> 3.0.0.rc1"
  gem "minitest-rails-capybara", "~> 3.0.0.rc1"
end

group :development, :test do
  gem "byebug"
end

group :development do
  gem "web-console"
  gem "listen"
end

group :production do
  gem "passenger"
  gem "rails_12factor"
end
