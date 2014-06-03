class RootPathController < ApplicationController
  include CategoryHandler

  respond_to :html, :xml, :json

  def handle_path
    path = URI.encode(params[:path].to_s)

    # No need to do this gsubbing if we don't need to.
    slug = path.gsub(/\A\/?(.+)\/?\z/, "\\1").downcase

    if @category = Category.find_by_slug(slug)
      handle_category and return
    else
      render_error(404, ActionController::RoutingError.new("Not Found"))
    end
  end
end
