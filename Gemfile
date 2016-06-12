ruby "2.3.1"
source "https://rubygems.org"

gem "rails", ">= 5.0.0.rc1", "< 5.1"
gem "pg", "~> 0.18"
gem "puma", "~> 3.0"
gem "therubyracer", platforms: :ruby

gem "bcrypt"
gem "jbuilder", "~> 2.0"
gem "jquery-rails"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "turbolinks", "~> 5.x"

gem "devise"
gem "omniauth"
gem "omniauth-slack"
gem "omniauth-google"
gem "omniauth-github"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

group :development, :test do
  gem "byebug"
end

group :development do
  gem "web-console"
  gem "listen", "~> 3.0.5"
end

group :production do
  gem "passenger"
  gem "rails_12factor"
end
