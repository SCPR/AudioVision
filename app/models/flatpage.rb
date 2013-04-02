class Flatpage < ActiveRecord::Base
  outpost_model

  validates :path, presence: true
  validates :title, presence: true
end
