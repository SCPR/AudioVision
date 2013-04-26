require 'spec_helper'

describe Post do
  describe '::with_related_kpcc_article' do
    it 'returns any posts whose related_kpcc_article_url is not blank or null' do
      create :post, related_kpcc_article_url: ""
      create :post, related_kpcc_article_url: nil
      post = create :post, related_kpcc_article_url: "http://scpr.org"
      
      Post.with_related_kpcc_article.should eq [post]
    end
  end

  describe '::force_recache_of_related_kpcc_articles' do
    it 'recaches any post with a kpcc article' do
      posts = create_list :post, 2, related_kpcc_article_url: "http://scpr.org"
      Post.force_recache_of_related_kpcc_articles
    end
  end


  describe '#related_kpcc_article' do
    let(:post) { create :post, related_kpcc_article_url: "http://www.scpr.org/blogs/newmedia/2013/04/17/13333/interview-harry-shearer-on-le-show-being-taken-off/?slide=6" }

    before :each do
      @kpcc_article = Kpcc::Article.find_by_url(post.related_kpcc_article_url)
    end

    it 'is nil if the url is blank' do
      post.related_kpcc_article_json_is_cached = true
      post.related_kpcc_article_url = nil

      post.related_kpcc_article.should eq nil
    end

    it 'returns the cache if it is available' do
      Rails.cache.write(post.related_kpcc_article_cache_key, @kpcc_article)
      post.related_kpcc_article.should eq @kpcc_article
    end

    it 'caches and returns the article if it is not set' do
      Rails.cache.delete(post.related_kpcc_article_cache_key)
      post.related_kpcc_article.should eq @kpcc_article
      Rails.cache.read(post.related_kpcc_article_cache_key).should eq @kpcc_article
    end

    it "returns nil if the url is invalid" do
      FakeWeb.clean_registry
      FakeWeb.register_assethost

      FakeWeb.register_uri(:any, %r|scpr\.org\/api\/v2\/content\/by_url\?url=not_found|, 
        :content_type => "application/json", 
        :status       => ["404", "Not Found"],
        :body         => { error: "Not Found" }.to_json
      )

      nogood_post = create :post, related_kpcc_article_url: "not_found"
      nogood_post.related_kpcc_article.should eq nil
    end
  end


  describe '#related_kpcc_article_cache_key' do
    it "is nil if the url is blank" do
      post = build :post, related_kpcc_article_url: nil
      post.related_kpcc_article_cache_key.should eq nil
    end

    it 'contains the url if it is set' do
      post = create :post, related_kpcc_article_url: "http://scpr.org"
      post.related_kpcc_article_cache_key.should match /scpr\.org/
    end
  end
end
