source 'https://rubygems.org'
ruby "2.4.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'json', github: 'flori/json', branch: 'v1.8'

# Bootstrap
gem 'bootstrap-sass', '~> 3.3.0'
gem 'autoprefixer-rails'
gem 'bootstrap-select-rails'

# HTML&CSS
gem 'html2slim'
gem 'slim-rails'
gem "font-awesome-rails"

# Pagination
gem 'kaminari'
gem 'kaminari-mongoid'

# Database
gem 'mongoid', '~> 5.0'
gem 'bson_ext'
#gem 'mongoid_search'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'
gem 'redis-rack-cache'

# Crawl
gem 'anemone'

# BH
gem 'bh', '~> 1.3'

# SMS
gem 'alidayu_api', require: "alidayu"
# Wechat
gem 'wechat'
# DoubleCall
gem 'yuntongxun_api'

# SEO
gem 'meta-tags'
gem 'sitemap_generator'
gem 'mongoid-slug'

# Schedule
gem 'whenever', :require => false

# Settings
gem 'figaro'

# Documention
gem 'apipie-rails'

# Analytics
gem 'google-analytics-rails'

# Bower
gem 'bower-rails'

# Loading
gem 'pace-rails'

# PDF&ZIP
gem 'rubyzip'
gem 'kristin'

# Mail
gem 'mail'

# Heroku
gem 'informant-rails'
gem 'buttercms-rails'

# Comments
gem 'mongoid_commentable', :git => 'https://github.com/skji/mongoid_commentable.git'
gem 'responders', '~> 2.0'

# Chart
gem 'chartjs-ror'

# Alipay
gem 'alipay', '~> 0.12.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Admin
gem 'rails_admin', '~> 1.2'
gem 'rails_admin_rollincode', '~> 1.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-byebug'
  #gem 'did_you_mean'
  gem 'rails-footnotes', '~> 4.0'
  gem 'rubycritic'
  gem 'railroady'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'brakeman', :require => false
  #gem 'query_reviewer'
  gem 'rack-mini-profiler', :require => false
  # For memory profiling
  gem 'memory_profiler'

  # For call-stack profiling flamegraphs
  gem 'flamegraph'
  gem 'stackprof'
end

group :production do
  gem 'rails_12factor'
end
