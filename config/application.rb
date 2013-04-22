require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module AudioVision
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Pacific Time (US & Canada)'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.scpr = ActiveSupport::OrderedOptions.new
    
    config.secrets = YAML.load_file("#{Rails.root}/config/app_config.yml")

    config.assethost = ActiveSupport::OrderedOptions.new
    config.assethost.server = "a.scpr.org"
    config.assethost.token  = "droQQ2LcESKeGPzldQr7" 
    config.assethost.prefix = "/api"

    config.autoload_paths += %W( #{config.root}/lib )

    # Precompile additional assets.
    # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
    config.assets.precompile += %w( outpost/application.css outpost/application.js *.png *.jpg *.jpeg *.gif display-ie.css )
  end
end
