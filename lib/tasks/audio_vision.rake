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
  end


  desc "Cache the KPCC Popular Articles"
  task :cache_kpcc_popular_articles => [:environment] do
    log "Enqueing Popular KPCC Article cache. (Do you have a resque working running?)"
    Resque.enqueue(Job::CachePopularKpccArticlesJob)
  end
end
