class Bucket < ActiveRecord::Base
  outpost_model
  
  has_many :post_references, as: :referrer
  has_many :posts, through: :post_references

  accepts_json_input_for_content(name: :post_references)

  after_save -> { self.touch }

  def build_content_association(content_hash, content)
    PostReference.new(
      :post       => content,
      :referrer   => self,
      :position   => content_hash['position'].to_i
    )
  end
end
