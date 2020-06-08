# frozen_string_literal: true

redis_conn = proc {
  Redis.new(url: Figaro.env.REDIS_URL)
}

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &redis_conn)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 25, &redis_conn)
end
