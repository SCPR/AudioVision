class FeedController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @posts = Post.published.page(params[:page]).per(15)

    if params[:category].present?
      @category = Category.find_by_slug(params[:category])
      @posts.where!(category_id: @category.id)
      feed_title = @category.title.pluralize
    else
      feed_title = "Posts"
    end

    if request.format.xml?
      @feed = {
        :title          => "Recent #{feed_title}",
        :href           => feed_url(category: @category.try(:slug)),
        :description    => "The most recent #{feed_title} from AudioVision."
      }
    end

    respond_with @posts
  end
end