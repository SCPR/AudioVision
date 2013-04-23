class PostsController < ApplicationController
  respond_to :html, :json

  def show
    @post       = Post.includes(:attributions, :category).find(params[:id])
    @category   = @post.category

    @nav_highlight = @category.slug
    
    @recent_posts_this_category      = Post.published.where("category_id = ?", @category.id).where('id != ?', @post.id).limit(2)
    @recent_posts_not_this_category  = Post.published.where("category_id != ?", @category.id).limit(4)

    respond_with @post
  end
end
