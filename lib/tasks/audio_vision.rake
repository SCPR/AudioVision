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

  desc "Rebuild the caches that don't rebuild on first-serve"
  task :rebuild_cache => [:environment] do
    Rake::Task["av:cache_kpcc_popular_articles"].invoke
    Rake::Task["av:related_articles:force_recache"].invoke
  end


  desc "Cache the KPCC Popular Articles"
  task :cache_kpcc_popular_articles => [:environment] do
    log "Enqueing Popular KPCC Article cache. (Do you have a resque working running?)"
    Resque.enqueue(Job::CachePopularKpccArticlesJob)
  end


  namespace :related_articles do
    desc "Enqueue cache of empty related KPCC articles"
    task :fill_empty_cache => [:environment] do
      log "Enqueing KPCC Article cache. (Do you have a resque working running?)"
      Post.enqueue_cache_for_empty_related_kpcc_articles
    end

    # Don't schedule this task via cron - 
    # it's for emergency manual recaching, and will take up a lot of 
    # resources when you run it.
    desc "Force a recache of all related KPCC articles"
    task :force_recache => [:environment] do
      log "Enqueing KPCC Article force-recache. (Do you have a resque working running?)"
      Post.force_recache_of_related_kpcc_articles
    end
  end
end


