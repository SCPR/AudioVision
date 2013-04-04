class PostsController < ApplicationController
  FakePost = Struct.new(:media_type, :related_articles)
  
  respond_to :html, :xml

  def show
    @post = FakePost.new(params[:media_type] || "image", params[:related_articles])
  end

  def archive
    @posts = Post.published.order("published_at desc")
      .page(params[:page]).per(15)
    
    if request.format.xml?
      @feed = {
        :title          => "Recent Posts",
        :href           => "http://audiovision.scpr.org/archive",
        :description    => "The most recent posts from AudioVision."
      }
    end

    respond_with @posts
  end
end
