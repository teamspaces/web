# API & Landing


### Assets

#### How it works
- Sprockets load gulpified assets
- Gulp compiles fonts, images (SVG etc.), stylesheets, javascripts. Look in `gulp/config.js`.

#### Building
`docker-compose run api gulp`

### Form Objects using Inflorm

Documentation: https://github.com/influitive/inflorm

```ruby
class ParentForm
  include Inflorm

  attribute :name,  String
  attribute :title, String

  attribute :child, ChildForm      # has_one association
  attribute :pets,  Array[PetForm] # has_many association

  validates :name,  presence: true
  validates :child, associated: true
  validates :pets,  associated: true
end

class ChildForm
  include Inflorm

  attribute :age, Integer

  validates :age, presence: true
end

class PetForm
  include Inflorm

  attribute :name,    String
  attribute :species, String

  validates :name,    presence: true
  validates :species, presence: true
end
```

### Working with Slack
Access the app here: https://api.slack.com/apps

Default configuration for all allowed URLs to sign in is:
```
http://localhost:5510/users/auth/slack/callback
http://127.0.0.1.nip.io:5510/users/auth/slack/callback
http://192.168.99.100:5510/users/auth/slack/callback
http://192.168.99.101:5510/users/auth/slack/callback
http://192.168.99.100.nip.io:5510/users/auth/slack/callback
http://192.168.99.101.nip.io:5510/users/auth/slack/callback
```

## Other
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
