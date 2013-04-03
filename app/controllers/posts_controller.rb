class PostsController < ApplicationController
  FakePost = Struct.new(:media_type, :related_articles)

  def index
  end

  def show
    @post = FakePost.new(params[:media_type] || "image", params[:related_articles])
  end

  def archive
  end
end
