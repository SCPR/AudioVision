require 'spec_helper'

describe PostsController do
  describe 'GET show' do
    render_views

    let(:category1) { create :category }
    let(:category2) { create :category }
    let(:post) { create :post, category: category1 }

    it 'finds the post' do
      get :show, post.route_hash
      assigns(:post).should eq post
    end

    it "sets the recent posts, and does not include this post" do
      posts_category1 = create_list :post, 1, category: category1
      posts_category2 = create_list :post, 1, category: category2

      get :show, post.route_hash
      assigns(:recent_posts_this_category).should eq posts_category1
      assigns(:recent_posts_not_this_category).should eq posts_category2
    end

    it "can respond with json" do
      get :show, post.route_hash.merge(format: :json)
      response.should render_template 'show'
      response.headers['Content-Type'].should match /json/
    end

    context "for image" do
      it "renders properly" do
        post = create :post, post_type: Post::POST_TYPES[:image]
        create_list :post_asset, 3, post: post
        get :show, post.route_hash

        response.should render_template partial: 'posts/post_types/_image'
      end
    end

    context "for slideshow" do
      it "renders properly" do
        post = create :post, post_type: Post::POST_TYPES[:slideshow]
        create_list :post_asset, 3, post: post
        get :show, post.route_hash

        response.should render_template partial: 'posts/post_types/_slideshow'
      end
    end

    context "for video" do
      it "renders properly" do
        post = create :post, post_type: Post::POST_TYPES[:video]
        create_list :post_asset, 3, post: post
        get :show, post.route_hash

        response.should render_template partial: 'posts/post_types/_video'
      end
    end

    context "for gallery" do
      it "renders properly" do
        post = create :post, post_type: Post::POST_TYPES[:gallery]
        create_list :post_asset, 3, post: post
        get :show, post.route_hash

        response.should render_template partial: 'posts/post_types/_gallery'
      end
    end
  end
end
