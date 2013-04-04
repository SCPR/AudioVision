class Category < ActiveRecord::Base
  outpost_model
  ROUTE_KEY = "root_slug"
  
  has_many :posts

  validates :slug, presence: true
  validates :title, presence: true

  def route_hash
    return {} if !self.persisted?
    { path: self.persisted_record.slug }
  end
end
