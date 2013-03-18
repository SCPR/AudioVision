class Post < ActiveRecord::Base
  MEDIA_TYPES = {
    :slideshow => "slideshow"
  }

  STATUS = {
    :draft     => 0,
    :published => 1
  }

  has_many :assets, class_name: "PostAsset", order: "position"
  has_many :authors

  def draft?
    self.staus == STATUS[:draft]
  end

  def published?
    self.status == STATUS[:published]
  end

  def slideshow?
    self.media_type == MEDIA_TYPES[:slideshow]
  end
end
