class PostReference < ActiveRecord::Base
  belongs_to :post
  belongs_to :referrer, polymorphic: true

  def simple_json
    @simple_json ||= {
      "id"          => self.post.try(:obj_key),
      "position"    => self.position.to_i
    }
  end
end
