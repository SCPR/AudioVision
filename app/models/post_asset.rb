class PostAsset < ActiveRecord::Base
  include Outpost::AssetHost::JoinModelJson

  belongs_to :post

  delegate :title, :size, 
    :taken_at, :owner, :url, :api_url, 
    :native, :image_file_size,
    :lsquare, :small, :eight, :full, to: :asset


  def asset
    @asset ||= begin
      _asset = AssetHost::Asset.find(self.asset_id)
    
      if _asset.is_a? AssetHost::Asset::Fallback
        self.caption = "We encountered a problem, and this photo is currently unavailable."
      end
      
      _asset
    end
  end
end
