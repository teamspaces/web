ruby "2.3.3"
source "https://rubygems.org"

gem "rails", "~> 5.0.0"
gem "pg"
gem "mongoid"
gem "puma"
gem "sidekiq"

gem "envied"
gem "lograge"
gem "bcrypt"
gem "jbuilder"
gem "jquery-rails"
gem "sass-rails"
gem "uglifier"
gem "aws-sdk"

gem "inflorm"
gem "interactor-rails", "~> 2.0"
gem "devise"
gem "pundit"
gem 'omniauth-slack', git: 'https://github.com/teamspaces/omniauth-slack.git', branch: 'auth-hash-fixes'
gem "httparty"
gem "jwt"
gem "json-schema"

gem 'draper', "~> 3.0.0.pre1"

gem "image_processing"
gem "mini_magick", ">= 4.3.5"
gem "shrine"
gem "avatarly"

gem "slack-ruby-client"
gem "sentry-raven"
gem "skylight"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

group :test do
  gem "mocha"
  gem "shoulda-context"
  gem "shoulda", "~> 3.5"
  gem "shoulda-matchers", "~> 2.0"
  gem "poltergeist"
  gem "database_cleaner"
end

group :development, :test do
  gem "minitest-rails-capybara"
  gem "minitest-reporters"
  gem "minitest-around"
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
