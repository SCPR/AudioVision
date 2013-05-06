require 'spec_helper'

describe FeedController do
  describe 'GET index' do
    render_views

    it "gets the recent posts" do
      posts = create_list :post, 2

      get :index

      # `published` scope orders the posts by reverse publish date,
      # but they are created in the opposite order, so we need to 
      # reverse them
      assigns(:posts).to_a.should eq posts.reverse
    end

    it "limits by category if present" do
      category_image = create :category, title: "Images"
      category_video = create :category, title: "Video"

      posts_image = create_list :post, 2, category: category_image
      posts_video = create_list :post, 2, category: category_video

      get :index, category: category_image.slug

      assigns(:category).should eq category_image
      assigns(:posts).to_a.should eq posts_image.reverse
    end


    it "renders the HTML format by default" do
      get :index
      response.should render_template("index")
      response.header['Content-Type'].should match /html/
    end

    it "can render XML" do
      get :index, format: :xml
      response.should render_template("index")
      response.header['Content-Type'].should match /xml/
    end

    it "can render JSON" do
      get :index, format: :json
      response.should render_template("index")
      response.header['Content-Type'].should match /json/
    end
  end
end
