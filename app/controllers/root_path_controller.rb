class RootPathController < ApplicationController
  include FlatpageHandler
  include CategoryHandler

  respond_to :html, :xml, :json

  def handle_path
    path = URI.encode(params[:path].to_s)

    if @flatpage = Flatpage.find_by_path("/#{path.downcase}/")
      handle_flatpage and return
    else
      # No need to do this gsubbing if we don't need to.
      slug = path.gsub(/\A\/?(.+)\/?\z/, "\\1").downcase

      if @category = Category.find_by_slug(slug)
        handle_category and return
      else
        raise ActionController::RoutingError.new("Not Found")
      end
    end
  end
end
