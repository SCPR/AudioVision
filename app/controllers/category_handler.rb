module CategoryHandler
  def handle_category
    @nav_highlight = @category.slug

    @posts = @category.posts.published.page(params[:page]).per(13)

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
      format.json
    end
  end
end
