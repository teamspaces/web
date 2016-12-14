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

gem "inflorm"
gem "interactor-rails", "~> 2.0"
gem "devise"
gem "pundit"
gem 'omniauth-slack', :git => 'https://github.com/ginjo/omniauth-slack.git', :branch => 'auth-hash-fixes'
gem "httparty"
gem "jwt"

# Required by draper: https://github.com/drapergem/draper/issues/697
gem "activemodel-serializers-xml", git: "https://github.com/rails/activemodel-serializers-xml"
gem 'draper', github: 'drapergem/draper'

gem "slack-ruby-client"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

group :test do
  gem "minitest-rails"
  gem "minitest-rails-capybara"
  gem "mocha"
  gem "shoulda-context"
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'
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
