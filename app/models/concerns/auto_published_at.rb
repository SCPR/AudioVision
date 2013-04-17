module AutoPublishedAt
  extend ActiveSupport::Concern

  included do
    before_validation :set_published_at_to_now, if: -> { self.published? && self.published_at.blank? }
    before_validation :set_published_at_to_nil, if: -> { !self.published? && self.published_at.present? }

    validates :published_at, presence: true, if: :published?
  end


  # Set published_at to Time.now
  def set_published_at_to_now
    self.published_at = Time.now
  end

  # Set published_at to nil
  def set_published_at_to_nil
    self.published_at = nil
  end
end
