require 'spec_helper'

describe Api::Public::V1::BucketsController do
  request_params = {
    :format => :json
  }


  describe "GET index" do
    it "Gets all of the buckets" do
      buckets = create_list :bucket, 2
      
      get :index, request_params
      assigns(:buckets).should eq buckets
    end
  end
end
