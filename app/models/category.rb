class Category < ActiveRecord::Base
  outpost_model
  has_secretary

  self.public_route_key = "root_slug"

  has_many :posts

  validates :slug, presence: true
  validates :title, presence: true

  def route_hash
    return {} if !self.persisted?
    { path: self.persisted_record.slug }
  end
end
