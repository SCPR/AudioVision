class Bucket < ActiveRecord::Base
  outpost_model
  
  has_many :post_references, as: :referrer
  has_many :posts, through: :post_references
end
