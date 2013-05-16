class FeedController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @nav_highlight = "archive"
    @posts = Post.published.includes(:attributions, :assets, :category).page(params[:page]).per(16)

    if params[:category].present?
      @category = Category.find_by_slug(params[:category])
      @posts.where!(category_id: @category.id)
      feed_title = "#{@category.title.pluralize} | AudioVision | KPCC"
    else
      feed_title = "AudioVision | KPCC"
    end

    if request.format.xml?
      @feed = {
        :title          => feed_title,
        :href           => feed_url(category: @category.try(:slug)),
        :description    => "From Southern California, public radio for your eyes."
      }
    end

    respond_with @posts
  end
end
