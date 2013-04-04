class Category < ActiveRecord::Base
  outpost_model
  
  has_many :posts

  validates :slug, presence: true
  validates :title, presence: true
end
