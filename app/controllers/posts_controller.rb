class PostsController < ApplicationController  
  respond_to :html, :xml

  def show
    @post = Post.find(params[:id])
    @nav_highlight = @post.category.slug
  end

  def archive
    @nav_highlight = "archive"

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
