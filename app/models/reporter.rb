class Reporter < ActiveRecord::Base
  outpost_model
  belongs_to :user
end
