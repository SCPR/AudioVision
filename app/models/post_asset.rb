class PostAsset < ActiveRecord::Base
  belongs_to :post

  delegate :caption, :title, :id, :size, 
    :taken_at, :owner, :url, :api_url, 
    :native, :image_file_size, to: :asset


  def asset
    @asset ||= begin
      a = AssetHost::Asset.find(self.asset_id)
    
      if a.is_a? AssetHost::Fallback
        self.caption = "We encountered a problem, and this photo is currently unavailable."
      end
      
      a
    end
  end
end
