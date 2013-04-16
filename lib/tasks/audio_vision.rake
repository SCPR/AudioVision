namespace :audio_vision do
  desc "Fire pending alarms"
  task :fire_alarms => [:environment] do
    puts "*** [#{Time.now}] Firing pending alarms..."
    PublishAlarm.fire_pending
    puts "Finished."
  end
end
