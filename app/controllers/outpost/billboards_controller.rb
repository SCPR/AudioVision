class Outpost::BillboardsController < Outpost::ResourceController
  outpost_controller

  private

  def form_params
    params.require(model.singular_route_key).permit(
      :layout, :status, :published_at, :content_json
    )
  end
end
