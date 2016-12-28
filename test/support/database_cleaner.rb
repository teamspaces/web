require "database_cleaner"


DatabaseCleaner[:active_record].strategy = :truncation
DatabaseCleaner[:mongoid].strategy = :truncation
