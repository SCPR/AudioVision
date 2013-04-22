namespace :audio_vision do
  desc "Fire pending alarms"
  task :fire_alarms => [:environment] do
    puts "*** [#{Time.now}] Firing pending alarms..."
    PublishAlarm.fire_pending
    puts "Finished."
  end

  desc "Enqueue cache of related KPCC articles"
  task :cache_related_articles => [:environment] do
    puts "*** [#{Time.now}] Enqueing KPCC Article cache."
    Post.enqueue_cache_for_empty_related_kpcc_articles
    puts "Finished."
  end
end
