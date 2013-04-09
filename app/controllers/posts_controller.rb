class PostsController < ApplicationController  
  respond_to :html, :xml, :json

  def show
    @post = Post.find(params[:id])
    @nav_highlight = @post.category.slug
    respond_with @post
  end

  def archive
    @nav_highlight = "archive"

    @posts = Post.published.page(params[:page]).per(15)
    
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
