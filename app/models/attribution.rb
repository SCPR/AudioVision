class Attribution < ActiveRecord::Base
  ROLE_AUTHOR       = 1
  ROLE_CONTRIBUTOR  = 2
  ROLE_SOURCE       = 3

  ROLE_TEXT = {
    ROLE_AUTHOR         => "Author",
    ROLE_CONTRIBUTOR    => "Contributor",
    ROLE_SOURCE         => "Source"
  }

  belongs_to :post
  belongs_to :reporter

  class << self
    def roles_collection
      ROLE_TEXT.map { |k, v| [v, k] }
    end
  end
end
