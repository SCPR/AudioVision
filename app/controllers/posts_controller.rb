class PostsController < ApplicationController
  FakePost = Struct.new(:media_type, :related_articles)

  def index
    # This is the homepage.
  end
  
  def show
    @post = FakePost.new(params[:media_type] || "image", params[:related_articles])
  end

  def archive
    @posts = Post.published.order("published_at desc")
  end
end
