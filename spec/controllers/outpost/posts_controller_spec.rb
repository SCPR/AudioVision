require 'spec_helper'

describe Outpost::PostsController do
  before :each do
    user = create :user
    controller.stub(:current_user) { user }
    user.permissions << Permission.find_by_resource("Post")
  end

  describe "Preview" do
    render_views

    context "existing article" do
      it "Renders the preview if everything is validated" do
        post = create :post
        put :preview, obj_key: post.obj_key, post: post.attributes, id: post.id
        assigns(:post).should eq post
        response.should render_template partial: "posts/_post"
      end

      it "Shows the updated attributes if anything changed" do
        post = create :post, title: "Original Headline"
        put :preview, obj_key: post.obj_key, post: post.attributes.merge(title: "Erpderted Herdlern"), id: post.id
        response.should render_template partial: "posts/_post"
        response.body.should match /Erpderted Herdlern/
      end

      it "renders validation errors if there are any" do
        post = create :post
        put :preview, obj_key: post.obj_key, post: post.attributes.merge(title: ""), id: post.id
        response.should_not render_template partial: "posts/_post"
        response.body.should render_template partial: "outpost/shared/_preview_errors"
      end

      it "renders okay for draft posts" do
        post = create :post, status: Post::STATUS[:draft]
        put :preview, obj_key: post.obj_key, post: post.attributes, id: post.id

        response.should render_template partial: "posts/_post"
      end
    end


    context "new article" do
      it "Renders the preview if everything is validated" do
        _post = build :post, title: "wohee"
        post :preview, post: _post.attributes
        assigns(:post).title.should eq "wohee"
        response.should render_template partial: "posts/_post"
      end

      it "renders validation errors if there are any" do
        _post = build :post, title: ""
        post :preview, post: _post.attributes
        response.should_not render_template partial: "posts/_post"
        response.body.should render_template partial: "outpost/shared/_preview_errors"
      end
    end
  end
end
