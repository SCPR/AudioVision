source 'https://rubygems.org'

# Core
gem 'rails', '~> 4.0.0.beta1'
gem 'mysql2'
gem 'thinking-sphinx', '~> 3.0'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'jbuilder', '~> 1.0.1'
gem 'jquery-rails'
gem 'turbolinks'

group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'bootstrap-sass', '~> 2.2'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'capistrano'
end

## Test, Development
group :test, :development do
  gem "rspec-rails", "2.12.0"
  gem 'rb-fsevent', '~> 0.9'
  gem 'launchy'
  gem 'rb-readline'
  gem 'guard', '~> 1.5'
  gem 'guard-rspec'
end


## Test Only
group :test do
  gem 'simplecov', require: false
  gem 'factory_girl_rails', "~> 4.1"
  gem 'database_cleaner'
  gem 'capybara', "~> 2.0"
  gem 'shoulda-matchers'
  gem 'fakeweb'
end
