class Billboard < ActiveRecord::Base
  LAYOUTS = {
    1 => "Description for layout 1",
    2 => "Description for layout 2",
    3 => "Description for layout 3",
    4 => "Description for layout 4",
    5 => "Description for layout 5",
    6 => "Description for layout 6",
    7 => "Description for layout 7"
  }

  STATUS = {
    :draft     => 0,
    :pending   => 4,
    :published => 5
  }

  STATUS_TEXT = {
    STATUS[:draft]     => "Draft",
    STATUS[:pending]   => "Pending",
    STATUS[:published] => "Published"
  }

  scope :published, -> { where(status: STATUS[:published]) }


  has_many :billboard_posts
  has_many :posts, through: :billboard_posts
end
