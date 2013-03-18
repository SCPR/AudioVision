class Post < ActiveRecord::Base
  MEDIA_TYPES = {
    :slideshow => "slideshow"
  }

  STATUS = {
    :draft     => 0,
    :published => 1
  }

  has_many :assets, -> { order("position") }, class_name: "PostAsset"
  has_many :attributions

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
