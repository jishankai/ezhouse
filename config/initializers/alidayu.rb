# coding: utf-8
Alidayu.setup do |config|
  config.server     = ENV['alidayu_server']
  config.app_key    = ENV['alidayu_app_key']
  config.app_secret = ENV['alidayu_app_secret']
  config.sign_name  = ENV['alidayu_sign_name']
end
