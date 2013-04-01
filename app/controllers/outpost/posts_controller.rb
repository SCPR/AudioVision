class Outpost::PostsController < Outpost::ResourceController
  outpost_controller
  self.permitted_params = [:media_type, :title, :body, :teaser, :slug, :asset_json, :status, :published_at, :attributions]
end
