Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV["REDIS_URL"],
    network_timeout: [1, ENV["REDIS_NETWORK_TIMEOUT"].to_i].min
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV["REDIS_URL"],
    network_timeout: [1, ENV["REDIS_NETWORK_TIMEOUT"].to_i].min
  }
end
