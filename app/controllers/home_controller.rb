class HomeController < ApplicationController
  def homepage
    @nav_highlight = "home"

    @recent_posts   = Post.published.limit(11)
    @billboard      = Billboard.current

    # If we have a billboard, then don't show any of its posts in "Recent"
    if @billboard.present?
      @recent_posts.where!("id not in ?", @billboard.billboard_posts.map(&:post_id))
    end
  end
end
