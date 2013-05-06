require 'spec_helper'

describe Api::Private::V1::PostsController do
  render_views
  
    request_params = {
    :format     => :json,
    :auth_token => "doesntactuallydoanythingyet"
  }

  describe "GET show" do
    it "finds the object if it exists" do
      post = create :post
      get :show, { id: post.id }.merge(request_params)
      assigns(:post).should eq post
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: "nope" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end


  describe "GET by_url" do
    it "finds the object if the URI matches" do
      post = create :post
      get :by_url, { url: post.remote_link_path }.merge(request_params)
      assigns(:post).should eq post
      response.should render_template "show"
    end

    it "validates the URI, returning a bad request if not valid" do
      get :by_url, { url: '###' }.merge(request_params)
      response.response_code.should eq 400
    end

    it "returns a 404 if no object is found" do
      get :by_url, { url: "nope.com" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end


  describe "GET index" do
    before :each do
      @published_posts = create_list :post, 3, status: Post::STATUS[:published]
    end

    it "get the posts" do
      get :index, request_params
      # Posts get created in ascending published_at, so reverse them
      assigns(:posts).should eq @published_posts.reverse
    end

    it "sanitizes the limit" do
      get :index, { limit: "1 Evil Code" }.merge(request_params)
      assigns(:limit).should eq 1
      assigns(:posts).should eq [@published_posts.last]
    end

    it "accepts a limit" do
      get :index, { limit: 1 }.merge(request_params)
      assigns(:posts).size.should eq 1
    end

    it "sanitizes the page" do
      get :index, { page: "Evil Code" }.merge(request_params)
      assigns(:page).should eq 1
      assigns(:posts).size.should eq @published_posts.size
    end

    it "accepts a page" do
        get :index, request_params
        third_obj = assigns(:posts)[2]

        get :index, { page: 3, limit: 1 }.merge(request_params)
        assigns(:posts).should eq [third_obj]
    end

    it "accepts a query" do
      post = create :post, title: "Spongebob Squarepants!"

      get :index, { query: "Spongebob" }.merge(request_params)
      assigns(:posts).should eq [post]
    end

    it "only grabs published posts" do
      unpublished_post = create :post, status: Post::STATUS[:draft]

      get :index, request_params
      assigns(:posts).should_not include unpublished_post
    end
  end
end
