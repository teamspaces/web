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
gem "sidekiq" # Background workers
gem "webpacker", "~> 2.0"
gem "sidekiq-symbols" # Adds symbol support to job arguments
gem "clockwork", require: false # Scheduler (config/schedule.rb)

gem "thor" # Powerful alternative to Rake (http://whatisthor.com/)
gem "terminal-table" # Pretty tables for CLI / Console

gem "envied" # Force ENVs on boot (Envfile)
gem "lograge" # Reduce the noise on Rails logger
gem "bcrypt"
gem "aws-sdk"

gem "httparty"
gem "oj" # Faster JSON
gem "jbuilder" # JSON presenters
gem "jwt" # API authorization
gem "json-schema" # Verify JSON schemas

gem "paranoia", "~> 2.2" # Soft-delete records
gem "virtus"
gem "interactor-rails", "~> 2.1.1" # Service (Interactor) Objects
gem "devise" # Authentication and basic Authorization
gem 'omniauth-slack', git: 'https://github.com/teamspaces/omniauth-slack.git', branch: 'auth-hash-fixes'
gem "pundit" # Easy and powerful authorization
gem "authie", "~> 3.0" # Database-backed session store

gem "elasticsearch"
gem "faraday_middleware-aws-signers-v4" # Auth for AWS Elasticsearch endpoint
gem "searchkick" # Easier to work with Elasticsearch
gem "searchjoy" # Search analytics

gem 'draper', "~> 3.0.0" # View presenters

gem "shrine" # File uploads
gem "image_processing"
gem "mini_magick", ">= 4.3.5"

gem "avatarly" # Generate avatars from name
gem "closure_tree" # Model tree relation support

gem "slack-ruby-client"
gem "sentry-raven"

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
  gem "skylight" # Application performance monitoring
end
