class Post < ActiveRecord::Base
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

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
  validates :media_type, presence: true, inclusion: { in: MEDIA_TYPES.values }

  validates :body, presence: true, if: :should_validate?
  validates :teaser, :subtitle, presence: true, if: :should_validate?

  def needs_validation?
    self.pending? || self.published?
  end



  # Callbacks
  before_validation :generate_slug, if: -> { self.should_validate? && self.slug.blank? }

  # Every save will trigger an API request to fetch the related KPCC article.
  # This also serves as a way to refresh the cached article, if it has changed.
  after_save :enqueue_related_kpcc_article_job, if: -> { self.related_kpcc_article_url.present? }
  after_save :clear_related_kpcc_article_cache, if: -> { self.related_kpcc_article_url_changed? && self.related_kpcc_article_url.blank? }

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

    # Enqueue a cache job for any article whose kpcc article is present,
    # but not the cache. This method is run from a rake task periodically,
    # and is only meant to be a safety net for if the cache is 
    # cleared but the related KPCC articles aren't manually recached.
    #
    # If the cache is cleared, ::force_recache_of_related_kpcc_articles
    # should be run manually.
    #
    # This method depends on the idea that if the Rails cache is cleared,
    # eventually the system will see the discrepancy between the "is_cached"
    # boolean, and the actual state of the cache. Then the next time this 
    # gets run, its cache will be rebuilt.
    def enqueue_cache_for_empty_related_kpcc_articles
      self.with_related_kpcc_article
        .where(related_kpcc_article_json_is_cached: false)
        .find_in_batches do |group|
        group.each do |post|
          if !Rails.cache.read(post.related_kpcc_article_cache_key)
            post.enqueue_related_kpcc_article_job
          end
        end
      end
    end

    # This method should only be run when a brute-force recache of all
    # related kpcc articles is necessary.
    # It will force a recache of the related KPCC article for any post
    # that has a related_kpcc_article_url set.
    def force_recache_of_related_kpcc_articles
      self.with_related_kpcc_article.find_in_batches do |group|
        group.each do |post|
          post.enqueue_related_kpcc_article_job
        end
      end
    end
  end


  #-------------------
  # Related KPCC Article
  def related_kpcc_article_cache_key
    return nil if !self.persisted?
    @related_kpcc_article_cache_key ||= "#{self.obj_key}/related_kpcc_article_json"
  end

  # If the boolean is false, just return nil.
  # If it's true, then we check the cache. If the article is indeed
  # cached, then return it. If it's not cached, then we need to set
  # the boolean to false.
  #
  # Don't enqueue a job here to cache the article - this will be 
  # susceptible to problems caused by race conditions. The cache needs
  # happen manually from the server.
  def related_kpcc_article
    @related_kpcc_article ||= begin
      return nil if !self.related_kpcc_article_json_is_cached? || 
      self.related_kpcc_article_url.blank?
    
      if cache = Rails.cache.read(related_kpcc_article_cache_key)
        cache
      else
        self.update_column(:related_kpcc_article_json_is_cached, false)
        nil
      end
    end
  end

  def enqueue_related_kpcc_article_job
    return false if self.related_kpcc_article_url.blank?
    Resque.enqueue(Job::RelatedKpccArticleJob, self.id)
  end

  def cache_related_kpcc_article_json
    return false if self.related_kpcc_article_url.blank?

    if article = Kpcc::Article.find_by_url(self.related_kpcc_article_url)
      self.update_column(:related_kpcc_article_json_is_cached, true)
      self.touch
      Rails.cache.write(related_kpcc_article_cache_key, article)
      true
    else
      false
    end
  end

  add_transaction_tracer :cache_related_kpcc_article_json, category: :task

  def clear_related_kpcc_article_cache
    Rails.cache.delete(related_kpcc_article_cache_key)
    self.update_column(:related_kpcc_article_json_is_cached, false)
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
    self.attributions.for_byline.map(&:display_name).to_sentence
  end


  #-------------------
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
