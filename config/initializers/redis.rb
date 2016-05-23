# config/initializers/redis.rb
$redis = Redis::Namespace.new("_stella_cache", :redis => Redis.new)
