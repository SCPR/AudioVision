class HomeController < ApplicationController
  def homepage
    @nav_highlight = "home"

    @billboard          = Billboard.published.includes(:post_references).first
    @recent_posts       = Post.published.limit(15)
    @midway_bucket      = Bucket.where(key: "instagram").first
    @right_bar_bucket   = Bucket.where(key: "featured-posts").first

    # If we have a billboard, then don't show any of its posts in "Recent"
    if @billboard.present? && @billboard.post_references.present?
      @recent_posts.where!("id not in (?)", @billboard.post_references.map(&:post_id))
    end
  end
end
