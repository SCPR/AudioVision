module CategoryHandler
  def handle_category
    @posts = @category.posts.published.order("published_at desc").limit(15)
    respond_with @content, template: "posts/category"
  end
end
