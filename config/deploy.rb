require "bundler/capistrano"
require 'net/http'
require 'new_relic/recipes'

# --------------
# Universal Variables

set :application, "audio_vision"
set :scm, :git
set :repository,  "git@github.com:SCPR/AudioVision.git"
set :scm_verbose, true
set :deploy_via, :remote_cache
set :deploy_to, "/web/audiovision"
set :keep_releases, 5

set :user, "audiovision"
set :use_sudo, false
set :group_writable, false


media = "66.226.4.228"

role :app,      media
role :web,      media
role :workers,  media
role :db,       media, :primary => true



# --------------
# Callbacks
before "deploy:update_code", "deploy:notify"
before "deploy:assets:precompile", "deploy:symlink_config"
after "deploy:update", "deploy:cleanup"
after "deploy:restart", "newrelic:notice_deployment"


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  # --------------
  
  task :notify do
    data = {
      :token  => "droQQ2LcESKeGPzldQr7",
      :user        => `whoami`.gsub("\n", ""),
      :datetime    => Time.now.strftime("%F %T"),
      :application => application
    }
    
    url = "http://www.scpr.org/api/private/v1/utility/notify"
    logger.info "Sending notification to #{url}"

    begin
      Net::HTTP.post_form(URI.parse(URI.encode(url)), data)
    rescue Errno::ETIMEDOUT => e
      logger.info "Timed out while trying to notify. Moving forward."
    end
  end

  # --------------

  task :symlink_config do
    %w{ database.yml app_config.yml newrelic.yml }.each do |file|
      run "ln -nfs #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
  end
end
