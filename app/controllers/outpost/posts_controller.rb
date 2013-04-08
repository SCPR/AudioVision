class Outpost::PostsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.column :title
    l.column :media_type, display: ->(r) { Post::MEDIA_TYPES_TEXT[r.media_type] }
    l.column :status
    l.column :published_at
    l.column :updated_at

    l.filter :media_type, collection: -> { Post.media_types_collection }
    l.filter :status, collection: -> { Post.status_collection }
  end


  private

  def form_params
    params.require(model.singular_route_key)
      .permit(
        :media_type, :title, :body, :teaser, :slug, 
        :asset_json, :status, :published_at, :category_id,
        { attributions_attributes: [:reporter_id, :name, :url, :role, :_destroy, :id] }
      )
  end
end
