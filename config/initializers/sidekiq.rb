Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"] || "localhost:6379" }
end
