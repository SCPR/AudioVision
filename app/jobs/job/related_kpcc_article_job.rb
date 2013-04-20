module Job
  class RelatedKpccArticleJob
    @queue = "audiovision"

    # Pass in the obj_key of the post that this is for, 
    # and the URL we want to fetch.
    def self.perform(obj_key, url)
      if article = Kpcc::Article.find_by_url(url)
        Rails.cache.write("#{obj_key}/related_kpcc_article_json", article)
      end
    end
  end
end
