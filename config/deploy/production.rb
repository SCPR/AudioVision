require 'new_relic/recipes'
require 'net/http'

# --------------
# Variables
set :branch, "master"
set :rails_env, "production"

# --------------
# Roles
media = "66.226.4.228"

role :app,      media
role :web,      media
role :workers,  media
role :db,       media, :primary => true
role :sphinx,   media

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
end


# --------------
# Callbacks
before "deploy:update_code", "deploy:notify"
after "deploy:update_code", "thinking_sphinx:configure"
after "deploy:update", "newrelic:notice_deployment"
