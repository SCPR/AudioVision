source 'https://rubygems.org'

gem 'rails', '~> 4.0.0.beta1'
gem 'mysql2'
gem 'thinking-sphinx', '~> 3.0'
gem 'jbuilder', '~> 1.0.1'
gem 'jquery-rails'
gem 'turbolinks'
gem 'outpost', github: "SCPR/outpost"

gem 'redis-store', github: "bricker/redis-store"
gem 'redis-actionpack', github: "bricker/redis-store"
gem 'redis-activesupport', github: "bricker/redis-store"
gem 'redis-rack', github: "bricker/redis-store"

gem "faraday", "~> 0.8"
gem "faraday_middleware", "~> 0.8"
gem "hashie", "~> 1.2.0"

group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'bootstrap-sass', '~> 2.2'
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
