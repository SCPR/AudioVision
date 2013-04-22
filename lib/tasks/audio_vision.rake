namespace :av do
  desc "Fire pending alarms"
  task :fire_alarms => [:environment] do
    puts "*** [#{Time.now}] Firing pending alarms..."
    PublishAlarm.fire_pending
    puts "Finished."
  end


  desc "Enqueue cache of empty related KPCC articles"
  task :cache_related_articles => [:environment] do
    puts "*** [#{Time.now}] Enqueing KPCC Article cache."
    Post.enqueue_cache_for_empty_related_kpcc_articles
    puts "Finished."
  end


  desc "Force a recache of all related KPCC articles"
  task :force_cache_related_articles => [:environment] do
    puts "*** [#{Time.now}] Enqueing KPCC Article force-recache."
    Post.force_recache_of_related_kpcc_articles
    puts "Finished."
  end
end
