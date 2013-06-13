class Outpost::BucketsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.column :title
    l.column :description
    l.column :key
  end


  private

  def form_params
    permitted = [:title, :description, :post_references_json]
    permitted += [:key] if action_name == "create"
    params.require(model.singular_route_key).permit(*permitted)
  end
end
