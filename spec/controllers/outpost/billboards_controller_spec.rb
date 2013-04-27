require 'spec_helper'

describe Outpost::BillboardsController do
  before :each do
    user = create :user
    controller.stub(:current_user) { user }
    user.permissions << Permission.find_by_resource("Billboard")
  end

  describe "Preview" do
    render_views

    context "existing billboard" do
      it "Renders the preview if everything is validated" do
        billboard = create :billboard
        put :preview, obj_key: billboard.obj_key, billboard: billboard.attributes, id: billboard.id
        assigns(:billboard).should eq billboard
        response.should render_template partial: "billboards/_billboard"
      end

      it "Shows the updated attributes if anything changed" do
        billboard = create :billboard, layout: 1
        put :preview, obj_key: billboard.obj_key, billboard: billboard.attributes.merge(layout: 2), id: billboard.id
        response.should render_template partial: "billboards/_layout_2"
      end

      it "renders validation errors if there are any" do
        billboard = create :billboard
        put :preview, obj_key: billboard.obj_key, billboard: billboard.attributes.merge(layout: ""), id: billboard.id
        response.should_not render_template partial: "billboards/_billboard"
        response.body.should render_template partial: "outpost/shared/_preview_errors"
      end
    end


    context "new billboard" do
      it "Renders the preview if everything is validated" do
        _billboard = build :billboard, layout: 1
        post :preview, billboard: _billboard.attributes
        assigns(:billboard).layout.should eq 1
        response.should render_template partial: "billboards/_billboard"
      end

      it "renders validation errors if there are any" do
        _billboard = build :billboard, layout: nil
        post :preview, billboard: _billboard.attributes
        response.should_not render_template partial: "billboards/_billboard"
        response.body.should render_template partial: "outpost/shared/_preview_errors"
      end
    end
  end
end
