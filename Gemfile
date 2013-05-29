source 'https://rubygems.org'

gem 'rails', github: "bricker/rails", branch: "allow_numbers_in_partial_names"
gem 'mysql2'
gem 'jquery-rails'
gem 'newrelic_rpm'
gem 'jbuilder'
gem 'resque', '~> 1.24'

#gem 'asset_host_client', path: "#{ENV['PROJECT_HOME']}/asset_host_client"
gem 'asset_host_client', github: "SCPR/asset_host_client"

#gem 'outpost', path: "#{ENV['PROJECT_HOME']}/outpost"
gem 'outpost', github: 'SCPR/outpost'

#gem 'outpost-asset_host', path: "#{ENV['PROJECT_HOME']}/outpost-asset_host"
gem 'outpost-asset_host', github: "SCPR/outpost-asset_host"

#gem 'outpost-aggregator', path: "#{ENV['PROJECT_HOME']}/outpost-aggregator"
gem 'outpost-aggregator', github: "SCPR/outpost-aggregator"

#gem 'outpost-publishing', path: "#{ENV['PROJECT_HOME']}/outpost-publishing"
gem 'outpost-publishing', github: "SCPR/outpost-publishing"


gem 'kaminari', github: "amatsuda/kaminari"
gem 'simple_form', '~> 3.0.0.beta1'
gem 'select2-rails', '~> 3.3'
gem 'bootstrap-sass', '~> 2.2'
gem 'escape_utils'

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
  gem 'dbsync'
end

group :test, :development do
  gem "rspec-rails", "~> 2.13.0"
  gem 'launchy'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-resque'
end

group :test do
  gem 'simplecov', require: false
  gem 'factory_girl_rails', "~> 4.1"
  gem 'database_cleaner', "~> 1.0"
  gem 'capybara', "~> 2.0"
  gem 'fakeweb'
end
