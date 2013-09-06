class HomeController < ApplicationController
  MIDWAY_BUCKET_KEY     = "public-square-community-project"
  RIGHT_BAR_BUCKET_KEY  = "featured-posts"

  def homepage
    @nav_highlight = "home"

    @billboard          = Billboard.published.includes(:post_references).first
    @recent_posts       = Post.published.limit(15)
    @midway_bucket      = Bucket.where(key: MIDWAY_BUCKET_KEY).first
    @right_bar_bucket   = Bucket.where(key: RIGHT_BAR_BUCKET_KEY).first

    # If we have a billboard, then don't show any of its posts in "Recent"
    if @billboard.present? && @billboard.post_references.present?
      @recent_posts.where!("id not in (?)", @billboard.post_references.map(&:post_id))
    end
  end
end
