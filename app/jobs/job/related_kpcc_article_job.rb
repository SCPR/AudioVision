module Job
  class RelatedKpccArticleJob
    @queue = "audiovision"

    # Pass in the obj_key of the post that this is for, 
    # and the URL we want to fetch.
    def self.perform(id)
      puts "Performing RelatedKpccArticleJob for Post #{id}"
      post = Post.find(id)
      post.cache_related_kpcc_article_json
    end
  end
end
