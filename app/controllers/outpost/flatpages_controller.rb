class Outpost::FlatpagesController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.column :title
    l.column :path
    l.column :description
    l.column :updated_at
  end


  private

  def form_params
    params.require(model.singular_route_key)
      .permit(
        :path, :title, :description, :content,
        :redirect_to, :extra_head, :extra_footer
      )
  end
end
