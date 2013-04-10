class Post < ActiveRecord::Base
  outpost_model
  ROUTE_KEY = "post"

  MEDIA_TYPES = {
    :image        => 0,
    :slideshow    => 1,
    :gallery      => 2,
    :video        => 3
  }

  MEDIA_TYPES_TEXT = {
    MEDIA_TYPES[:image]       => "Image",
    MEDIA_TYPES[:slideshow]   => "Slideshow",
    MEDIA_TYPES[:gallery]     => "Gallery",
    MEDIA_TYPES[:video]       => "Video",
  }

  # Keys for templates
  # Just reverses the MEDIA_TYPES hash.
  #
  #   MEDIA_TYPES_KEYS[0] => "image"
  MEDIA_TYPES_KEYS = Hash[MEDIA_TYPES.map { |k, v| [v, k.to_s] }]


  STATUS = {
    :killed    => -1,
    :draft     => 0,
    :pending   => 4,
    :published => 5
  }

  STATUS_TEXT = {
    STATUS[:killed]    => "Killed",
    STATUS[:draft]     => "Draft",
    STATUS[:pending]   => "Pending",
    STATUS[:published] => "Published"
  }

  scope :published, -> { where(status: STATUS[:published]).order("published_at desc") }

  # Associations
  has_many :assets, -> { order("position") }, class_name: "PostAsset", dependent: :destroy
  accepts_json_input_for_assets

  has_many :attributions, dependent: :destroy
  has_many :authors, -> { where(role: Attribution::ROLE_AUTHOR) }, class_name: "Attribution"
  has_many :contributors, -> { where(role: Attribution::ROLE_CONTRIBUTOR) }, class_name: "Attribution"

  belongs_to :category

  has_many :post_references, dependent: :destroy

  accepts_nested_attributes_for :attributions, allow_destroy: true, reject_if: :should_reject_attributions?

  def should_reject_attributions?(attributes)
    attributes['reporter_id'].blank? &&
    attributes['name'].blank?
  end

  def asset
    @asset ||= self.assets.first || AssetHost::Fallback.new
  end


  def json
    {
      :id           => self.obj_key,
      :title        => self.to_title,
      :published_at => self.published_at,
      :teaser       => self.teaser,
      :body         => self.body,
      :permalink    => self.remote_link_path,
      :asset        => self.asset.lsquare.tag,
      :byline       => self.byline,
      :edit_link    => self.admin_edit_path
    }
  end

  # Validations
  validates :slug, {
    :if       => :should_validate?,
    :presence => true,
    :length   => { maximum: 50 },
    :format   => { 
      :with    => %r{\A[\w-]+\z}, 
      :message => "Only letters, numbers, underscores, and hyphens allowed"
    }
  }

  validates :title, presence: true
  validates :status, presence: true

  # We want to really enforce that the media types are correct, because they
  # get mapped directly to partial names.
  validates :media_type, presence: true, inclusion: { in: MEDIA_TYPES.values }

  validates :body, presence: true, if: :should_validate?
  validates :published_at, presence: true, if: :published?
  validates :teaser, presence: true, if: :should_validate?

  def should_validate?
    self.pending? || self.published?
  end


  # Callbacks
  before_validation :generate_slug,           if: -> { self.should_validate? && self.slug.blank? }
  before_validation :set_published_at_to_now, if: -> { self.published? && self.published_at.blank? }
  before_validation :set_published_at_to_nil, if: -> { !self.published? && self.published_at.present? }


  def generate_slug
    if self.title.present?
      self.slug = self.title.parameterize[0...50].sub(/-+\z/, "")
    end
  end

  # Set published_at to Time.now
  def set_published_at_to_now
    self.published_at = Time.now
  end

  # Set published_at to nil
  def set_published_at_to_nil
    self.published_at = nil
  end



  class << self
    def media_types_collection
      MEDIA_TYPES_TEXT.map { |k, v| [v, k] }
    end

    def status_collection
      STATUS_TEXT.map { |k, v| [v, k] }
    end

    def by_url(url)
      begin
        u = URI.parse(url)
      rescue URI::InvalidURIError
        return nil
      end
      
      u.path.match(%r{\A/(\d+)}) do |match|
        Post.find_by_id(match[1])
      end
    end
  end


  def related_kpcc_article
    @related_kpcc_article ||= begin
      if json = Rails.cache.fetch("#{self.obj_key}/related_article_json")
        Kpcc::Article.new(JSON.parse(json))
      end
    end
  end


  def byline
    self.attributions.map(&:to_s).join(" | ")
  end

  def media_type_key
    MEDIA_TYPES_KEYS[self.media_type]
  end



  # Status methods
  def pending?
    self.status == STATUS[:pending]
  end

  def published?
    self.status == STATUS[:published]
  end



  def route_hash
    return {} if !self.persisted? || !self.persisted_record.published?
    {
      :id     => self.id,
      :slug   => self.persisted_record.slug
    }
  end
end
