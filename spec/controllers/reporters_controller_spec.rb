require 'spec_helper'

describe ReportersController do
  describe 'GET index' do
    render_views

    it 'grabs only is_listed reporters' do
      listed    = create :reporter, is_listed: true
      unlisted  = create :reporter, is_listed: false

      get :index
      assigns(:reporters).should eq [listed]
    end
  end

  describe 'GET show' do
    render_views

    it 'finds reporter by slug and assigns his posts' do
      reporter           = create :reporter
      published_post     = create :post, status: Post::STATUS[:published]
      unpublished_post   = create :post, status: Post::STATUS[:draft]

      create :attribution, reporter: reporter, post: published_post
      create :attribution, reporter: reporter, post: unpublished_post

      get :show, reporter.route_hash

      assigns(:reporter).should eq reporter
      assigns(:posts).should eq [published_post]
    end
  end
end
