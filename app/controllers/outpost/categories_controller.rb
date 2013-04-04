class Outpost::CategoriesController < Outpost::ResourceController
  outpost_controller


  private

  def form_params
    params.require(model.singular_route_key)
      .permit(
        :title, :slug, :description
      )
  end
end
