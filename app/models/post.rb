class Post < ActiveRecord::Base
  outpost_model
  
  MEDIA_TYPES = {
    :slideshow => "slideshow"
  }

  STATUS = {
    :killed    => -1,
    :draft     => 0,
    :pending   => 4,
    :published => 5
  }


  # Associations
  has_many :assets, -> { order("position") }, class_name: "PostAsset", dependent: :destroy
  has_many :attributions, dependent: :destroy
  has_many :authors, -> { where(role: Attribution::ROLE_AUTHOR) }, class_name: "Attribution"
  has_many :contributors, -> { where(role: Attribution::ROLE_CONTRIBUTOR) }, class_name: "Attribution"


  # Validations
  validates :slug, {
    :format => { 
      :with    => %r{\A[\w-]+\z}, 
      :message => "Only letters, numbers, underscores, and hyphens allowed" 
    },
    :length   => { maximum: 50 },
    :presence => true
  }

  validates :title, presence: true
  validates :status, presence: true
  validates :body, presence: true
  validates :published_at, presence: true, if: -> { self.published? }
  validates :teaser, presence: true
  validates :media_type, presence: true

  def should_validate?
    self.pending? || self.published?
  end


  # Callbacks
  before_validation :generate_slug,           if: -> { self.should_validate? && self.slug.blank? }
  before_validation :set_published_at_to_now, if: -> { self.published? && self.published_at.blank? }
  before_validation :set_published_at_to_nil, if: -> { !self.published? && self.published_at.present? }


  # Set published_at to Time.now
  def set_published_at_to_now
    self.published_at = Time.now
  end

  # Set published_at to nil
  def set_published_at_to_nil
    self.published_at = nil
  end

  def generate_slug
    if self.title.present?
      self.slug = self.title.parameterize[0...50].sub(/-+\z/, "")
    end
  end


  # Status methods
  def pending?
    self.status == STATUS[:pending]
  end

  def published?
    self.status == STATUS[:published]
  end


  # Asset Handling
  # Define these methods manually since Rails uses a cache (not method_missing 
  # directly) to call them, and we don't want (or need) to reset that.
  def assets_changed?
    attribute_changed?('assets')
  end

  #-------------------
  # #asset_json is a way to pass in a string representation
  # of a javascript object to the model, which will then be
  # parsed and turned into ContentAsset objects in the 
  # #asset_json= method.
  def asset_json
    current_assets_json.to_json
  end

  #-------------------
  # Parse the input from #asset_json and turn it into real
  # ContentAsset objects. 
  def asset_json=(json)
    # If this is literally an empty string (as opposed to an 
    # empty JSON object, which is what it would be if there were no assets),
    # then we can assume something went wrong and just abort.
    # This shouldn't happen since we're populating the field in the template.
    return if json.empty?

    json = Array(JSON.parse(json)).sort_by { |c| c["position"].to_i }
    loaded_assets = []
    
    json.each do |asset_hash|
      new_asset = PostAsset.new(
        :asset_id    => asset_hash["id"].to_i, 
        :caption     => asset_hash["caption"].to_s, 
        :position    => asset_hash["position"].to_i
      )
      
      loaded_assets.push new_asset
    end
    
    loaded_assets_json = assets_to_simple_json(loaded_assets)

    # If the assets didn't change, there's no need to bother the database.        
    if current_assets_json != loaded_assets_json
      self.changed_attributes['assets'] = current_assets_json
      self.assets = loaded_assets
    end

    self.assets
  end


  class << self
    def media_types_collection
      MEDIA_TYPES.map { |k, v| [k.to_s.titleize, v] }
    end

    def status_collection
      STATUS.map { |k, v| [k.to_s.titleize, v] }
    end
  end



  private

  def current_assets_json
    assets_to_simple_json(self.assets)
  end

  def assets_to_simple_json(array)
    Array(array).map(&:simple_json)
  end
end
