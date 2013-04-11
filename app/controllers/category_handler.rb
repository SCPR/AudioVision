module CategoryHandler
  def handle_category
    @nav_highlight = @category.slug
    @posts = @category.posts.published.limit(13)
    render 'posts/category'
  end
end
