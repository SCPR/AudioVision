require 'spec_helper'

describe Bucket do
  describe "::posts" do
    it 'only grabs published posts' do
      bucket = create :bucket
      post_unpublished = create :post, status: Post::STATUS[:draft]
      post_published   = create :post, status: Post::STATUS[:published]
      bucket.posts = [post_unpublished, post_published]

      bucket.reload.posts.should eq [post_published]
    end
  end
end
