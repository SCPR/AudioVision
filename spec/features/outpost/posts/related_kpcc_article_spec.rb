require 'spec_helper'

describe "Related KPCC Articles for Posts" do
  describe "Caching" do
    before :each do
      login
      @user.permissions << Permission.find_by_resource("Post")
    end

    let(:post) { create :post, related_kpcc_article_url: "http://www.scpr.org/news/2013/04/25/36978/senate-passes-bill-to-ease-faa-furloughs-including/" }
    
    it "Caches the article if it's available" do
      post.related_kpcc_article.should_not eq nil

      visit post.admin_edit_path
      check 'post__update_related_kpcc_article_cache'
      click_button 'Save'

      rpost = Post.find(post.id) # reload to clear out cache

      rpost.related_kpcc_article.should_not eq nil
      visit rpost.link_path
      page.should have_content rpost.related_kpcc_article.short_title
    end

    it "Returns empty if the URL is emptied" do
      post.related_kpcc_article.should_not eq nil

      visit post.admin_edit_path
      fill_in 'post_related_kpcc_article_url', with: ""
      click_button 'Save'

      rpost = Post.find(post.id) # reload to clear out cache

      rpost.related_kpcc_article.should eq nil
      visit rpost.link_path
      page.should_not have_content "Pebble Beach" # from scpr_content.json
    end
  end
end
