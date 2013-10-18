module PublishedScope
  extend ActiveSupport::Concern

  included do
    scope :published, -> {
      where(status: self::STATUS[:published]).order("published_at desc")
    }
  end
end
