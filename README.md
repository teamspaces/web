# API & Landing

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
