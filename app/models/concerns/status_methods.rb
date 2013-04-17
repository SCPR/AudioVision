module StatusMethods
  extend ActiveSupport::Concern

  module ClassMethods
    def status_collection
      self::STATUS_TEXT.map { |k, v| [v, k] }
    end
  end


  def pending?
    self.status == self.class::STATUS[:pending]
  end

  def published?
    self.status == self.class::STATUS[:published]
  end

  def status_text
    self.class::STATUS_TEXT[self.status]
  end
end
