class Reporter < ActiveRecord::Base
  outpost_model
  belongs_to :user

  validates :name, presence: true
  validates :slug, presence: true
  validates :user, presence: true

  class << self
    def select_collection
      self.all.map { |r| [r.name, r.id] }
    end
  end
end
