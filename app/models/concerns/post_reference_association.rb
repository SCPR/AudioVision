module PostReferenceAssociation
  extend ActiveSupport::Concern

  included do
    has_many :post_references,
      -> { order('position') },
      :as           => :referrer,
      :dependent    => :destroy

    if self.has_secretary?
      tracks_association :post_references
    end

    has_many :posts,
      -> { where(status: Post::STATUS[:published]) },
      :through => :post_references

    accepts_json_input_for :post_references
  end


  private

  def build_post_reference_association(post_reference_hash, post)
    if post.published?
      PostReference.new(
        :post       => post,
        :referrer   => self,
        :position   => post_reference_hash['position'].to_i
      )
    end
  end
end
