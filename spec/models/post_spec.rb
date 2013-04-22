require 'spec_helper'

describe Post do
  describe '::enqueue_cache_for_empty_related_kpcc_articles' do
    it "enqueues a cache for any article with a url that it thinks isn't cached yet" do
      uncached_posts = create_list :post, 2, related_kpcc_article_url: "http://scpr.org", related_kpcc_article_json_is_cached: false
      cached_posts = create_list :post, 2, related_kpcc_article_url: "http://scpr.org", related_kpcc_article_json_is_cached: true
      
      uncached_posts.each do |post|
        post.related_kpcc_article.should eq nil
        post.related_kpcc_article_json_is_cached.should eq false
        Resque.should_receive(:enqueue).with(Job::RelatedKpccArticleJob, post.id) # meh
      end

      cached_posts.each do |post|
        Resque.should_not_receive(:enqueue).with(Job::RelatedKpccArticleJob, post.id) # double meh
      end

      Post.enqueue_cache_for_empty_related_kpcc_articles
    end
  end


  describe '::force_recache_of_related_kpcc_articles' do
    it 'recaches any post with a kpcc article' do
      posts = create_list :post, 2, related_kpcc_article_url: "http://scpr.org"
      
      posts.each do |post|
        post.related_kpcc_article.should eq nil
        Resque.should_receive(:enqueue).with(Job::RelatedKpccArticleJob, post.id)
      end

      Post.force_recache_of_related_kpcc_articles
    end
  end


  describe '#related_kpcc_article' do
    let(:post) { create :post, related_kpcc_article_url: "http://www.scpr.org/blogs/newmedia/2013/04/17/13333/interview-harry-shearer-on-le-show-being-taken-off/?slide=6" }

    before :each do
      FakeWeb.register_uri(:any, %r|scpr\.org\/api\/v2\/content|, 
        :content_type => "application/json", 
        :body         => File.read(Rails.root.join("spec/fixtures/scpr_content.json"))
      )

      @kpcc_article = Kpcc::Article.find_by_url(post.related_kpcc_article_url)
    end


    it 'is nil if it thinks the cache is not set' do
      post.related_kpcc_article_json_is_cached?.should eq false
      post.related_kpcc_article.should eq nil
    end

    it 'is nil if the url is blank' do
      post.related_kpcc_article_json_is_cached = true
      post.related_kpcc_article_url = nil

      post.related_kpcc_article.should eq nil
    end

    it 'returns the cache if it thinks it is set and it actually is' do
      post.related_kpcc_article_json_is_cached = true
      Rails.cache.write(post.related_kpcc_article_cache_key, @kpcc_article)

      post.related_kpcc_article.should eq @kpcc_article
    end

    it 'sets the boolean to false if it thinks the cache is present but it is actually not' do
      post.update_column(:related_kpcc_article_json_is_cached, true)
      Rails.cache.read(post.related_kpcc_article_cache_key).should eq nil

      post.related_kpcc_article.should eq nil
      post.related_kpcc_article_json_is_cached.should eq false
    end
  end


  describe '#related_kpcc_article_cache_key' do
    it "is nil if the object isn't persisted" do
      post = build :post
      post.related_kpcc_article_cache_key.should eq nil
    end

    it 'is the obj_key plus key if it is persisted' do
      post = create :post
      post.related_kpcc_article_cache_key.should eq "#{post.obj_key}/related_kpcc_article_json"
    end
  end


  describe '#enqueue_related_kpcc_article_job' do
    it 'returns false if the url is blank' do
      post = create :post, related_kpcc_article_url: nil
      post.enqueue_related_kpcc_article_job.should eq false
    end

    it 'enqueues the resque job' do
      post = build :post, id: 1, related_kpcc_article_url: "http://scpr.org"
      Resque.should_receive(:enqueue).with(Job::RelatedKpccArticleJob, post.id)
      post.enqueue_related_kpcc_article_job
    end

    it 'gets run after save if url is present' do
      post = build :post, related_kpcc_article_url: "http://scpr.org"
      post.should_receive(:enqueue_related_kpcc_article_job)
      post.save!
    end

    it 'does not get run if url is not present' do
      post = build :post, related_kpcc_article_url: nil
      post.should_not_receive(:enqueue_related_kpcc_article_job)
      post.save!
    end
  end


  describe '#cache_related_kpcc_article_json' do
    it 'is false if url is blank' do
      post = build :post, related_kpcc_article_url: nil
      post.cache_related_kpcc_article_json.should eq false
    end

    it 'is false if the article is not found' do
      FakeWeb.register_uri(:any, %r|scpr\.org\/api\/v2\/content\/by_url|, 
        :content_type => "application/json", 
        :body         => { error: "Invalid URL" }.to_json,
        :status       => ['400', "Bad Request"]
      )

      post = create :post, related_kpcc_article_url: "http://scpr.org"
      post.cache_related_kpcc_article_json.should eq false
    end

    it "updates the boolean and writes the cache if the article is available" do
      FakeWeb.register_uri(:any, %r|scpr\.org\/api\/v2\/content\/by_url|, 
        :content_type => "application/json", 
        :body         => File.read(Rails.root.join("spec/fixtures/scpr_content.json"))
      )

      post = create :post, related_kpcc_article_url: "http://scpr.org"
      post.related_kpcc_article_json_is_cached.should eq false
      Rails.cache.read(post.related_kpcc_article_cache_key).should eq nil

      post.cache_related_kpcc_article_json
      
      post.related_kpcc_article_json_is_cached.should eq true
      Rails.cache.read(post.related_kpcc_article_cache_key).should_not eq nil
      Rails.cache.read(post.related_kpcc_article_cache_key).should eq post.related_kpcc_article
    end
  end


  describe '#clear_related_kpcc_article_cache' do
    before :each do
      FakeWeb.register_uri(:any, %r|scpr\.org\/api\/v2\/content\/by_url|, 
        :content_type => "application/json", 
        :body         => File.read(Rails.root.join("spec/fixtures/scpr_content.json"))
      )
    end

    it 'clears the cache and sets the boolean to false' do
      post = create :post, related_kpcc_article_url: "http://scpr.org"
      post.cache_related_kpcc_article_json
      post.related_kpcc_article.should be_present
      post.related_kpcc_article_json_is_cached.should eq true
      
      post.clear_related_kpcc_article_cache
      post.related_kpcc_article_json_is_cached.should eq false
      post.related_kpcc_article.should eq nil
    end

    it "runs after save if we unset the URL" do
      post = create :post, related_kpcc_article_url: "http://scpr.org"
      post.should_receive(:clear_related_kpcc_article_cache)

      post.related_kpcc_article_url = nil
      post.save!
    end
  end
end
