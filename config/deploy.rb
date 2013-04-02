require "bundler/capistrano"
require 'new_relic/recipes'
require 'net/http'

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

set :maintenance_template_path, "public/maintenance.erb"
set :maintenance_basename, "maintenance"

# Pass these in with -s to override: 
#    cap deploy -s force_assets=true
set :force_assets,  false # If assets wouldn't normally be precompiled, force them to be
set :skip_assets,   false # If assets are going to be precompiled, force them NOT to be



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
after "deploy:update", "newrelic:notice_deployment"


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
    
    url = "http://www.scpr.org/api/private/utility/notify"
    logger.info "Sending notification to #{url}"
    Net::HTTP.post_form(URI.parse(URI.encode(url)), data)
  end

  # --------------
  # Skip asset precompile if no assets were changed
  namespace :assets do
    task :precompile, roles: :web do
      from = source.next_revision(current_revision) rescue nil
      
      # Previous revision is blank or git log doesn't 
      # have any new lines mentioning assets
      if [true, 1].include?(force_assets) || from.nil? || 
          capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
          if ![true, 1].include? skip_assets
            run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
          else
            logger.info "SKIPPING asset pre-compilation (skip_assets true)"
          end
      else
        logger.info "No changes in assets. SKIPPING asset pre-compilation"
      end
    end
  end

  task :symlink_config do
    %w{ database.yml app_config.yml newrelic.yml }.each do |file|
      run "ln -nfs #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
  end
end
