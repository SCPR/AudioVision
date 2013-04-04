class Reporter < ActiveRecord::Base
  outpost_model
  ROUTE_KEY = "reporter"

  belongs_to :user

  validates :name, presence: true
  validates :slug, presence: true
  validates :user, presence: true

  def route_hash
    return {} if !self.persisted?
    {
      :slug => self.slug
    }
  end

  
  class << self
    def select_collection
      self.all.map { |r| [r.name, r.id] }
    end
  end
end
