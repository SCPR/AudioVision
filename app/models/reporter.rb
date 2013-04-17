class Reporter < ActiveRecord::Base
  outpost_model
  ROUTE_KEY = "reporter"

  belongs_to :user

  has_many :attributions
  has_many :posts, through: :attributions
  
  validates :name, presence: true
  validates :slug, presence: true
  validates :user, presence: true

  after_save -> { self.touch }

  class << self
    def select_collection
      self.all.map { |r| [r.name, r.id] }
    end
  end


  def asset
    if self.asset_id.present?
      @asset ||= AssetHost::Asset.find(self.asset_id)
    end
  end


  def route_hash
    return {} if !self.persisted?
    {
      :slug => self.slug
    }
  end
end
