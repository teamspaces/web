Rails.application.config.generators do |g|
  g.test_framework :minitest, spec: true
  g.helper false
  g.assets false
  g.orm :active_record
end
