require 'spec_helper'

describe Api::Public::V1::BucketsController do
  render_views
  
  request_params = {
    :format => :json
  }

  describe "GET show" do
    it "finds the object if it exists" do
      bucket = create :bucket
      bucket.posts = create_list :post, 2

      get :show, { id: bucket.key }.merge(request_params)
      
      assigns(:bucket).should eq bucket
      response.should render_template "show"
    end

    it "returns a 404 status if it does not exist" do
      get :show, { id: "nope" }.merge(request_params)
      response.response_code.should eq 404
      response.body.should eq Hash[error: "Not Found"].to_json
    end
  end


  describe "GET index" do
    before :each do
      @buckets = create_list :bucket, 2
    end

    it "get the buckets" do
      get :index, request_params
      assigns(:buckets).to_a.should eq @buckets
    end
  end
end
