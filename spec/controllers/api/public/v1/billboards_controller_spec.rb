require 'spec_helper'

describe Api::Public::V1::BillboardsController do
  render_views
  
  request_params = {
    :format => :json
  }

  describe "GET show" do
    it "finds the object if it exists" do
      billboard = create :billboard
      billboard.posts = create_list :post, 2

      get :show, { id: billboard.id }.merge(request_params)
      
      assigns(:billboard).should eq billboard
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
      @billboards = create_list :billboard, 2
    end

    it "get the billboards" do
      get :index, request_params
      assigns(:billboards).to_a.should eq @billboards
    end
  end


  describe "GET current" do
    it "gets the current billboard" do
      billboard_old       = create :billboard, published_at: 2.days.ago
      billboard_current   = create :billboard

      get :current, request_params
      assigns(:billboard).should eq billboard_current
    end
  end
end
