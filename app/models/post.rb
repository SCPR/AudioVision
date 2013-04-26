class Post < ActiveRecord::Base
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  outpost_model
  ROUTE_KEY = "post"

  include ConditionalValidation
  include Schedulable
  include StatusMethods
  include PublishedScope
  include AutoPublishedAt

  POST_TYPES = {
    :image        => 0,
    :slideshow    => 1,
    :gallery      => 2,
    :video        => 3,
    :sandbox      => 4
  }

  POST_TYPES_TEXT = {
    POST_TYPES[:image]       => "Image",
    POST_TYPES[:slideshow]   => "Slideshow",
    POST_TYPES[:gallery]     => "Gallery",
    POST_TYPES[:video]       => "Video",
    POST_TYPES[:sandbox]     => "Sandbox"
  }

  # Keys for templates
  # Just reverses the POST_TYPES hash.
  #
  #   POST_TYPES_KEYS[0] => "image"
  POST_TYPES_KEYS = Hash[POST_TYPES.map { |k, v| [v, k.to_s] }]


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


  scope :with_related_kpcc_article, -> { where('related_kpcc_article_url > ?', '') }

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
  validates :post_type, presence: true, inclusion: { in: POST_TYPES.values }

  validates :body, presence: true, if: :should_validate?
  validates :teaser, :subtitle, presence: true, if: :should_validate?

  def needs_validation?
    self.pending? || self.published?
  end



  # Callbacks
  before_validation :generate_slug, if: -> { self.should_validate? && self.slug.blank? }

  after_save :fetch_and_cache_related_kpcc_article, if: -> { self.related_kpcc_article_url_changed? && self.related_kpcc_article_url.present? }
  after_save :fetch_and_cache_related_kpcc_article, if: -> { self._update_related_kpcc_article_cache }

  # Always update the updated_at attribute, 
  # even if nothing was actually changed.
  after_save -> { self.touch }
  after_save :touch_referrers

  # Generate the slug based on the title.
  def generate_slug
    if self.title.present?
      self.slug = self.title.parameterize[0...50].sub(/-+\z/, "")
    end
  end

  # In order to expire the cache for referrers.
  def touch_referrers
    self.post_references.each { |r| r.touch }
  end



  class << self
    def post_types_collection
      POST_TYPES_TEXT.map { |k, v| [v, k] }
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

    # Utility method to refresh all of the related KPCC articles.
    # This method should only be run when a brute-force recache of all
    # related kpcc articles is necessary.
    # It will force a recache of the related KPCC article for any post
    # that has a related_kpcc_article_url set.
    def force_recache_of_related_kpcc_articles
      self.with_related_kpcc_article.find_in_batches do |group|
        group.each do |post|
          puts "Caching related article for #{post.simple_title}" unless Rails.env == "test"
          post.send :fetch_and_cache_related_kpcc_article
        end
      end
    end
  end


  #-------------------
  # Related KPCC Article

  attr_accessor :_update_related_kpcc_article_cache

  def related_kpcc_article_cache_key
    return nil if self.related_kpcc_article_url.blank?
    @related_kpcc_article_cache_key ||= "kpcc_article:url:#{self.related_kpcc_article_url}"
  end

  # If the article is indeed cached, then return it.
  # Otherwise find it and cache it.
  def related_kpcc_article
    @related_kpcc_article ||= begin
      return nil if self.related_kpcc_article_url.blank?
    
      if cache = Rails.cache.read(related_kpcc_article_cache_key)
        cache
      else
        fetch_and_cache_related_kpcc_article
      end
    end
  end


  #------------------
  # Grab the first asset. 
  # If for some reason it's empty, return a Fallback asset.
  def asset
    @asset ||= (self.assets.first || AssetHost::Asset::Fallback.new)
  end

  #-------------------
  # All bylines mixed into one.
  def byline
    @byline ||= self.attributions.for_byline.map(&:display_name).to_sentence
  end


  #-------------------
  # The key for the media type.
  # This is used for template rendering.
  #
  # Fallback to "image" in case something goes
  # horribly wrong.
  def post_type_key
    POST_TYPES_KEYS[self.post_type] || 'image'
  end


  def route_hash
    return {} if !self.persisted? || !self.persisted_record.published?
    {
      :id     => self.id,
      :slug   => self.persisted_record.slug
    }
  end



  private

  def fetch_and_cache_related_kpcc_article
    return false if self.related_kpcc_article_url.blank?

    if article = Kpcc::Article.find_by_url(self.related_kpcc_article_url)
      Rails.cache.write(related_kpcc_article_cache_key, article)
      article
    else
      nil
    end
  end

  add_transaction_tracer :fetch_and_cache_related_kpcc_article, category: :task

  #-------------------

  def should_reject_attributions?(attributes)
    attributes['reporter_id'].blank? &&
    attributes['name'].blank?
  end
end
