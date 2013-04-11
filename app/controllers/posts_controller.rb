class PostsController < ApplicationController
  def show
    @post       = Post.find(params[:id])
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

  def homepage
    @nav_highlight = "home"

    @recent_posts   = Post.published.limit(11)
    @billboard      = Billboard.current
    
    @midway_bucket    = Bucket.where(key: "instagram").first
    @right_bar_bucket = Bucket.where(key: "featured-posts").first

    # If we have a billboard, then don't show any of its posts in "Recent"
    if @billboard.present?
      @recent_posts.where!("id not in (?)", @billboard.post_references.map(&:post_id))
    end
  end
end
