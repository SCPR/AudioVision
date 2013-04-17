class Attribution < ActiveRecord::Base

  # Order is significant for these.
  # Attributions will be ordered by the numeric 
  # "role" attribute in ascending order.
  ROLE_AUTHOR       = 1
  ROLE_CONTRIBUTOR  = 2
  ROLE_SOURCE       = 3

  ROLE_TEXT = {
    ROLE_AUTHOR         => "Author",
    ROLE_CONTRIBUTOR    => "Contributor",
    ROLE_SOURCE         => "Source"
  }

  scope :for_byline, -> { where('role in (?)', [ROLE_AUTHOR, ROLE_SOURCE]).order('role') }
  
  belongs_to :post
  belongs_to :reporter


  class << self
    def roles_collection
      ROLE_TEXT.map { |k, v| [v, k] }
    end
  end

  def to_s
    if self.reporter.present?
      self.reporter.name
    else
      self.name
    end
  end
end
