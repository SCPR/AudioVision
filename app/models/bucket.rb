class Bucket < ActiveRecord::Base
  outpost_model
  include PostReferenceAssociation

  after_save -> { self.touch }
end
