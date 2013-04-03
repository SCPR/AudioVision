class Outpost::PostsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.column :title
    l.column :status
    l.column :media_type
    l.column :published_at
    l.column :updated_at

    l.filter :media_type, collection: -> { Post.media_types_collection }
  end


  private

  def form_params
    params.require(model.singular_route_key)
      .permit(
        :media_type, :title, :body, :teaser, :slug, 
        :asset_json, :status, :published_at, 
        { attributions_attributes: [:reporter_id, :name, :url, :role, :_destroy, :id] }
      )
  end
end
