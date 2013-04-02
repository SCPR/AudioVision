class Outpost::ReportersController < Outpost::ResourceController
  outpost_controller
  self.permitted_params = [:slug]
end
