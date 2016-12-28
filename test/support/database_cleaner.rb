require "database_cleaner"

DatabaseCleaner[:active_record].strategy = :transaction
DatabaseCleaner[:mongoid].strategy = :truncation
