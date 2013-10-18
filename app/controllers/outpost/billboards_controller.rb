class Outpost::BillboardsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.column :layout, display: ->(r) { r.layout_text }
    l.column :status
    l.column :published_at
    l.column :updated_at
  end

  
  def preview
    @billboard = Outpost.obj_by_key(params[:obj_key]) || Billboard.new
    
    with_rollback @billboard do
      @billboard.assign_attributes(form_params)

      if @billboard.valid?
        render "/billboards/_billboard",
          :layout => "outpost/preview/application",
          :locals => { billboard: @billboard }
      else
        render_preview_validation_errors(@billboard)
      end
    end
  end


  private

  def form_params
    params.require(model.singular_route_key).permit(
      :layout, :status, :published_at, :post_references_json,

      { publish_alarm_attributes: [
          :fire_at, :_destroy, :id
        ]
      }
    )
  end
end
