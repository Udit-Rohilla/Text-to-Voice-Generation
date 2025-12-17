Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'])

Rack::Attack.throttle('requests/ip', limit: 10, period: 60) do |req|
  req.ip
end
