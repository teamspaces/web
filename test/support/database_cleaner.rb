require "database_cleaner"

DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner[:active_record].strategy = :truncation
DatabaseCleaner[:mongoid].strategy = :truncation
