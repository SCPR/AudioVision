class Bucket < ActiveRecord::Base
  outpost_model
  has_secretary

  include PostReferenceAssociation

  after_save -> { self.touch }
end
