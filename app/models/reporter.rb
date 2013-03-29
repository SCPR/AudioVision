class Reporter < ActiveRecord::Base
  outpost_model
  belongs_to :user

  validates :name, presence: true
  validates :slug, presence: true
  validates :user, presence: true
end
