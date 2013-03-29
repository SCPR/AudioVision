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

  has_many :assets, -> { order("position") }, class_name: "PostAsset"
  has_many :attributions

  validates :title, presence: true

  validates :slug, {
    :format => { 
      :with    => %r{\A[\w-]+\z}, 
      :message => "Only letters, numbers, underscores, and hyphens allowed" 
    },
    :length   => { maximum: 50 },
    :presence => true
  }

  validates :status, presence: true
  validates :body, presence: true
  validates :published_at, presence: true
  validates :teaser, presence: true
  validates :media_type, presence: true

  before_validation :generate_slug, if: -> { self.slug.blank? }
  def generate_slug
    if self.title.present?
      self.slug = self.title.parameterize[0...50].sub(/-+\z/, "")
    end
  end

  def killed?
    self.status == STATUS[:killed]
  end

  def draft?
    self.status == STATUS[:draft]
  end

  def pending?
    self.status == STATUS[:pending]
  end

  def published?
    self.status == STATUS[:published]
  end

  def slideshow?
    self.media_type == MEDIA_TYPES[:slideshow]
  end

  class << self
    def media_types_collection
      MEDIA_TYPES.map { |k, v| [k.to_s.titleize, v] }
    end

    def status_collection
      STATUS.map { |k, v| [k.to_s.titleize, v] }
    end
  end
end
