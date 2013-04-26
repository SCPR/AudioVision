class Outpost::PostsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.column :title
    l.column :post_type, header: "Type", display: ->(r) { Post::POST_TYPES_TEXT[r.post_type] }
    l.column :byline
    l.column :status
    l.column :published_at
    l.column :updated_at

    l.filter :post_type, collection: -> { Post.post_types_collection }
    l.filter :status, collection: -> { Post.status_collection }
  end


  def preview
    @post = Outpost.obj_by_key(params[:obj_key]) || Post.new
    
    with_rollback @post do
      @post.assign_attributes(form_params)

      if @post.unconditionally_valid?
        render "/posts/_post", layout: "outpost/preview/application", locals: { post: @post }
      else
        render_preview_validation_errors(@post)
      end
    end
  end


  private

  def form_params
    params.require(model.singular_route_key)
      .permit(
        :post_type, :title, :subtitle, :body, :teaser, :slug, 
        :related_kpcc_article_url, :asset_json, :status, :published_at, 
        :category_id,

        { publish_alarm_attributes: [
            :fire_at, :_destroy, :id
          ]
        },

        { attributions_attributes: [
            :reporter_id, :name, :url, :role, :_destroy, :id
          ] 
        }
      )
  end
end
