require "database_cleaner"

DatabaseCleaner[:active_record].strategy = :deletion
DatabaseCleaner[:mongoid].strategy = :truncation
