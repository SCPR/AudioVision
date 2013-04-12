class PostsController < ApplicationController
  def show
    @post       = Post.includes(:attributions).find(params[:id])
    @category   = @post.category

    @nav_highlight = @category.slug
    
    @recent_posts_this_type      = Post.published.where("category_id = ?", @category.id).where('id != ?', @post.id).limit(2)
    @recent_posts_not_this_type  = Post.published.where("category_id != ?", @category.id).limit(4)

    respond_to do |format|
      format.html
      format.xml
      format.json
    end
  end
end
