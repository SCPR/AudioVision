config = YAML.load_file(File.expand_path("../deploy_config.yml", __FILE__))

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
set :deploy_to, config['deploy_to']
set :keep_releases, 5

set :user, config['user']
set :use_sudo, false
set :group_writable, false

role :app,      config["servers"]["app"]
role :web,      config["servers"]["app"]
role :workers,  config["servers"]["workers"]
role :db,       config["servers"]["db"], :primary => true



# --------------
# Callbacks
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

  task :symlink_config do
    %w{ database.yml app_config.yml api_config.yml newrelic.yml }.each do |file|
      run "ln -nfs #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
  end
end
