ruby "2.3.4"
source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.1.2"
gem "pg"
gem "mongoid"
gem "puma"
gem "sidekiq"

gem "thor"
gem "terminal-table"

gem "envied"
gem "lograge"
gem "bcrypt"
gem "paranoia", "~> 2.2"
gem "jbuilder"
gem "aws-sdk"

gem "interactor-rails", "~> 2.0"
gem "devise"
gem "authie", "~> 2.0"
gem "pundit"
gem 'omniauth-slack', git: 'https://github.com/teamspaces/omniauth-slack.git', branch: 'auth-hash-fixes'
gem "httparty"
gem "jwt"
gem "json-schema"
gem "virtus"

gem 'draper', "~> 3.0.0.pre1"

gem "image_processing"
gem "mini_magick", ">= 4.3.5"
gem "shrine"
gem "avatarly"
gem "closure_tree"

gem "slack-ruby-client"
gem "sentry-raven"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

group :test do
  gem "mocha"
  gem "shoulda-context"
  gem "shoulda", "~> 3.5"
  gem "shoulda-matchers", "~> 2.0"
  gem "poltergeist"
  gem "database_cleaner"
  gem "webmock"
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
  gem "skylight"
end
