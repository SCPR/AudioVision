namespace :av do
  desc "Fire pending alarms"
  task :fire_alarms => [:environment] do
    puts "*** [#{Time.now}] Firing pending alarms..."
    PublishAlarm.fire_pending
    puts "Finished."
  end


  desc "Cache the KPCC Popular Articles"
  task :cache_kpcc_popular_articles => [:environment] do
    true
  end


  namespace :related_articles do
    desc "Enqueue cache of empty related KPCC articles"
    task :fill_empty_cache => [:environment] do
      puts "*** [#{Time.now}] Enqueing KPCC Article cache."
      Post.enqueue_cache_for_empty_related_kpcc_articles
      puts "Finished."
    end

    # Don't schedule this task via cron - 
    # it's for emergency manual recaching, and will take up a lot of 
    # resources when you run it.
    desc "Force a recache of all related KPCC articles"
    task :force_recache => [:environment] do
      puts "*** [#{Time.now}] Enqueing KPCC Article force-recache."
      Post.force_recache_of_related_kpcc_articles
      puts "Finished."
    end
  end
end
