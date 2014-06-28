class PublishAlarm < ActiveRecord::Base
  scope :pending, -> { where("fire_at <= ?", Time.zone.now).order("fire_at") }
  belongs_to :content, polymorphic: true

  class << self
    #---------------------
    # Fire any pending alarms
    def fire_pending
      self.pending.each do |alarm|
        alarm.fire
      end
    end
  end

  #---------------------
  # Fire an alarm.
  def fire
    return false unless self.can_fire?

    if self.content.update_attributes(status: Post::STATUS[:published])
      self.destroy
    else
      false
    end
  end

  #---------------------

  def pending?
    self.fire_at <= Time.zone.now
  end

  #---------------------

  def can_fire?
    self.pending? && self.content.pending?
  end
end
