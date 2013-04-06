class Billboard < ActiveRecord::Base
  outpost_model

  LAYOUTS = {
    1 => "(1) TOP: Slideshow / BOTTOM: Video (16:9), Mobile (1:1)",
    2 => "(2) TOP: Slideshow / BOTTOM: Triptych of Images (3:2)",
    3 => "(3) TOP: Slideshow / BOTTOM: Pair of Videos (16:9)",
    4 => "(4) TOP: Video (16:9) + Mobile (1:1) / BOTTOM: Triptych of Images (3:2)",
    5 => "(5) TOP: Mobile (1:1) + Video (16:9) / BOTTOM: Triptych of Images (3:2)",
    6 => "(6) TOP: Mobile (1:1) + Image (3:2) / BOTTOM: Pair of Videos (16:9)",
    7 => "(7) TOP: Image (3:2) + Mobile (1:1) / BOTTOM: Pair of Videos (16:9)"
  }

  STATUS = {
    :draft     => 0,
    :pending   => 4,
    :published => 5
  }

  STATUS_TEXT = {
    STATUS[:draft]     => "Draft",
    STATUS[:pending]   => "Pending",
    STATUS[:published] => "Published"
  }

  scope :published, -> { where(status: STATUS[:published]) }

  validates :layout, presence: true, inclusion: { in: LAYOUTS.keys }
  validates :status, presence: true
  
  has_many :billboard_posts
  has_many :posts, through: :billboard_posts

  class << self
    def layouts_collection
      LAYOUTS.map { |k, v| [v, k] }
    end

    def status_collection
      STATUS_TEXT.map { |k, v| [v, k] }
    end
  end
end
