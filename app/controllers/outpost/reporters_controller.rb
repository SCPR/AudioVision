class Outpost::ReportersController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.column :name
    l.column :user
    l.column :slug
  end


  def authorize_resource
    if @record
      if current_user.profile == @record && %w{show edit update}.include?(action_name)
        return true
      end
    end

    super
  end


  private

  def form_params
    params.require(model.singular_route_key)
      .permit(
        :name, :slug, :bio, :user_id
      )
  end
end
