# config/initializers/yuntongxun.rb
YunTongXun.setup do |config|
  config.server = ENV["yuntongxun_server"]
  config.account_sid = ENV["yuntongxun_account_sid"]
  config.auth_token = ENV["yuntongxun_auth_token"]
  config.version = ENV["yuntongxun_version"]
  config.app_id = ENV["yuntongxun_app_id"]
end
