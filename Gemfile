source 'https://rubygems.org'

gem 'rails', '~> 4.0.0.beta1'
gem 'mysql2'
gem 'jquery-rails'
gem 'newrelic_rpm'

gem 'outpost', github: 'SCPR/outpost'
#gem 'outpost', path: '/Users/bryan/projects/outpost'
#gem 'outpost', path: '/Users/bricker/websites/kpcc/outpost'

#gem 'outpost-asset_host', path: "/Users/bryan/projects/outpost-asset_host"
gem 'outpost-asset_host', github: "SCPR/outpost-asset_host"

gem 'kaminari', github: "amatsuda/kaminari"
gem 'simple_form', '~> 3.0.0.beta1'
gem 'ckeditor_rails', '~> 4.1'
gem 'bootstrap-sass', '~> 2.2'

gem 'redis-store', github: "bricker/redis-store"
gem 'redis-actionpack', github: "bricker/redis-store"
gem 'redis-activesupport', github: "bricker/redis-store"
gem 'redis-rack', github: "bricker/redis-store"

gem "faraday", "~> 0.8"
gem "faraday_middleware", "~> 0.8"
gem "hashie", "~> 1.2.0"

group :assets do
  gem 'eco', '~> 1.0.0'
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'capistrano'
  gem 'pry'
end

group :test, :development do
  gem "rspec-rails", "2.12.0"
  gem 'launchy'
end

group :test do
  gem 'simplecov', require: false
  gem 'factory_girl_rails', "~> 4.1"
  gem 'database_cleaner'
  gem 'capybara', "~> 2.0"
  gem 'fakeweb'
end
