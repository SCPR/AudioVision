class PostAsset < ActiveRecord::Base
  belongs_to :post

  delegate :title, :size, 
    :taken_at, :owner, :url, :api_url, 
    :native, :image_file_size,
    :thumb, :small, :eight, :full, to: :asset


  def as_json(options={})
    @as_json ||= begin
      # grab asset as_json, merge in our values
      self.asset.as_json(options).merge!({
        "post_asset_id"   => self.id,
        "caption"         => self.caption,
        "ORDER"           => self.position,
        "credit"          => self.asset.owner
      })
    end
  end


  def simple_json
    @simple_json ||= {
      "id"          => self.asset_id.to_i,
      "caption"     => self.caption.to_s,
      "position"    => self.position.to_i
    }
  end


  def asset
    @asset ||= begin
      _asset = AssetHost::Asset.find(self.asset_id)
    
      if _asset.is_a? AssetHost::Fallback
        self.caption = "We encountered a problem, and this photo is currently unavailable."
      end
      
      _asset
    end
  end
end
