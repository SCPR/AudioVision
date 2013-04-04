module CategoryHandler
  def handle_category
    @posts = @category.posts.published
      .order("published_at desc").page(params[:page]).per(15)

    if request.format.xml?
      @feed = {
        :title          => @category.title,
        :href           => @category.remote_link_path,
        :description    => @category.description
      }
    end

    respond_with @posts do |format|
      format.html { render "posts/category" }
      format.xml { render "posts/archive" }
    end
  end
end
