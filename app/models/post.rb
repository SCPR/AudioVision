class Post < ActiveRecord::Base
  outpost_model
  ROUTE_KEY = "post"

  include ConditionalValidation
  include Schedulable
  include StatusMethods
  include PublishedScope
  include AutoPublishedAt

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



  # Associations
  has_many :assets, -> { order("position") }, class_name: "PostAsset", dependent: :destroy
  accepts_json_input_for_assets

  has_many :attributions, dependent: :destroy
  has_many :authors, -> { where(role: Attribution::ROLE_AUTHOR) }, class_name: "Attribution"
  has_many :contributors, -> { where(role: Attribution::ROLE_CONTRIBUTOR) }, class_name: "Attribution"
  accepts_nested_attributes_for :attributions, allow_destroy: true, reject_if: :should_reject_attributions?

  belongs_to :category

  has_many :post_references, dependent: :destroy



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
  validates :teaser, :subtitle, presence: true, if: :should_validate?

  def needs_validation?
    self.pending? || self.published?
  end



  # Callbacks
  before_validation :generate_slug, if: -> { self.should_validate? && self.slug.blank? }

#  after_save :enqueue_related_kpcc_article_job

  after_save -> { self.touch }
  after_save :touch_referrers

  # Generate the slug based on the title.
  def generate_slug
    if self.title.present?
      self.slug = self.title.parameterize[0...50].sub(/-+\z/, "")
    end
  end

  # Expire the cache for these.
  def touch_referrers
    self.post_references.each { |r| r.touch }
  end



  class << self
    def media_types_collection
      MEDIA_TYPES_TEXT.map { |k, v| [v, k] }
    end

    # Find a post by its URL.
    def find_by_url(url)
      begin
        u = URI.parse(url)
      rescue URI::InvalidURIError
        return nil
      end
      
      u.path.match(%r{\A/(\d+)}) do |match|
        Post.published.find_by_id(match[1])
      end
    end
  end


  # Related KPCC Article
  def enqueue_related_kpcc_article_job
    if self.related_kpcc_article_url.present?
      Resque.enqueue(Job::RelatedKpccArticleJob, self.related_kpcc_article_url)
    end
  end

  def related_kpcc_article
    return nil if self.related_kpcc_article_url.blank?

    if cache = Rails.cache.fetch("#{self.obj_key}/related_kpcc_article_json")
      cache
    else
      self.enqueue_related_kpcc_article_job
      nil
    end
  end


  #------------------
  # Grab the first asset. 
  # If for some reason it's empty, return a Fallback asset.
  def asset
    @asset ||= (self.assets.first || AssetHost::Fallback.new)
    @asset ||= (self.assets.first || AssetHost::Asset::Fallback.new)
  end

  #-------------------
  # All bylines mixed into one.
  def byline
    self.attributions.for_byline.map(&:to_s).to_sentence
  end


  # The key for the media type.
  # This is used for template rendering.
  def media_type_key
    MEDIA_TYPES_KEYS[self.media_type]
  end


  def route_hash
    return {} if !self.persisted? || !self.persisted_record.published?
    {
      :id     => self.id,
      :slug   => self.persisted_record.slug
    }
  end



  private

  def should_reject_attributions?(attributes)
    attributes['reporter_id'].blank? &&
    attributes['name'].blank?
  end
end
