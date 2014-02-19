require 'kpcc'

# Cache popular KPCC articles from KPCC API
module Job
  class CachePopularKpccArticlesJob < Base
    @queue = "audiovision"

    # Pass in the obj_key of the post that this is for,
    # and the URL we want to fetch.
    def self.perform
      if articles = Kpcc::Article.most_viewed
        Rails.cache.write("popular_kpcc_articles", articles)
      else
        raise "No articles available from the KPCC API!"
      end
    end
  end
end
