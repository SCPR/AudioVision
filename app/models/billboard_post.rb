class BillboardPost < ActiveRecord::Base
  belongs_to :post
  belongs_to :billboard
end
