class Attribution < ActiveRecord::Base
  belongs_to :post
  belongs_to :reporter
end
