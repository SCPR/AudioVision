class Billboard < ActiveRecord::Base
  outpost_model

  include Schedulable
  include StatusMethods
  include PublishedScope
  include AutoPublishedAt

  LAYOUTS = {
    1 => "1 - TOP: Slideshow / BOTTOM: Video (16:9), Mobile (1:1)",
    2 => "2 - TOP: Slideshow / BOTTOM: Triptych of Images (3:2)",
    3 => "3 - TOP: Slideshow / BOTTOM: Pair of Videos (16:9)",
    4 => "4 - TOP: Video (16:9) + Mobile (1:1) / BOTTOM: Triptych of Images (3:2)",
    5 => "5 - TOP: Mobile (1:1) + Video (16:9) / BOTTOM: Triptych of Images (3:2)",
    6 => "6 - TOP: Mobile (1:1) + Image (3:2) / BOTTOM: Pair of Videos (16:9)",
    7 => "7 - TOP: Image (3:2) + Mobile (1:1) / BOTTOM: Pair of Videos (16:9)"
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



  has_many :post_references, -> { order("position") }, as: :referrer, dependent: :destroy
  has_many :posts, through: :post_references

  accepts_json_input_for_content(name: :post_references)


  validates :layout, presence: true, inclusion: { in: LAYOUTS.keys }
  validates :status, presence: true


  after_save -> { self.touch }



  class << self
    def layouts_collection
      LAYOUTS.map { |k, v| [v, k] }
    end
  end


  private

  def build_content_association(content_hash, content)
    PostReference.new(
      :post       => content,
      :referrer   => self,
      :position   => content_hash['position'].to_i
    )
  end
end
