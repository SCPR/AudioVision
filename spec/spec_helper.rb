ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)

silence_warnings do
  # Minitest is giving warnings that we can ignore for now
  require 'rspec/rails'
end

require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods
  config.include AuthenticationHelper, type: :feature

  config.before :suite do
    DatabaseCleaner.clean_with(:truncation, except: ["permissions"])

    Outpost.config.registered_models.each do |model|
      Permission.create(resource: model)
    end
  end

  config.before :each do
    FakeWeb.clean_registry
    FakeWeb.load_callback

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.before type: :feature do
    DatabaseCleaner.strategy = :truncation, { except: ["permissions"] }
  end

  config.after :each do
    DatabaseCleaner.clean

    begin
      Rails.cache.clear
    rescue Errno::ENOENT => e
      warn e
    end
  end
end
