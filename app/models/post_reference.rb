class PostReference < ActiveRecord::Base
  belongs_to :post
  belongs_to :referrer, polymorphic: true
end
