def log(msg)
  puts "*** [#{Time.now}] #{msg}"
end


namespace :av do
  desc "Fire pending alarms"
  task :fire_alarms => [:environment] do
    log "Firing pending alarms... "
    PublishAlarm.fire_pending
    log "Finished.\n"
  end
end
