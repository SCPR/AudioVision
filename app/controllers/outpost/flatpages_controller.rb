class Outpost::FlatpagesController < Outpost::ResourceController
  outpost_controller
  self.permitted_params = [
    :path, :title, :description, :content, 
    :redirect_to, :extra_head, :extra_footer
  ]
  
end
