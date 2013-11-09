##
# ContentAlarmAssociation
#
# Association definition for publish_alarm
# Also includes related callbacks
#
# Required attributes: [:status]
#
module Schedulable
  extend ActiveSupport::Concern

  included do
    has_one :publish_alarm, as: :content, dependent: :destroy
    accepts_nested_attributes_for :publish_alarm, reject_if: :should_reject_publish_alarm?, allow_destroy: true

    before_save :destroy_publish_alarm, if: :should_destroy_publish_alarm?
  end

  #------------------
  # Reject if the alarm doesn't already exist and the fire_at
  # wasn't filled in.
  #
  # This allows someone to remove the scheduled publishing by
  # clearing out the fire_at fields.
  def should_reject_publish_alarm?(attributes)
    self.publish_alarm.blank? && attributes['fire_at'].blank?
  end

  #------------------
  # If we're changing status from Pending to something else,
  # and there was an alarm, get rid of it.
  # Also get rid of it if we saved it with blank fire_at fields.
  def should_destroy_publish_alarm?
    (self.publish_alarm.present? && self.status_changed? && self.status_was == self.class::STATUS[:pending]) ||
    (self.publish_alarm.present? && self.publish_alarm.fire_at.blank?)
  end

  #------------------
  # Mark the alarm for destruction
  def destroy_publish_alarm
    self.publish_alarm.mark_for_destruction
  end
end
