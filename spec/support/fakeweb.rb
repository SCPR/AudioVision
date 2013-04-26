FakeWeb.allow_net_connect = false

if !defined?(AH_JSON)
  AH_JSON = {
    :asset   => File.read("#{Rails.root}/lib/asset_host/fallback/asset.json"),
    :outputs => File.read("#{Rails.root}/lib/asset_host/fallback/outputs.json")
  }
end

module FakeWeb
  def self.load_callback
    register_assethost
    register_kpcc_api
  end

  def self.register_assethost
    FakeWeb.register_uri(:any, %r|a\.scpr\.org\/api\/outputs|, body: AH_JSON[:outputs], content_type: "application/json")
    FakeWeb.register_uri(:any, %r|a\.scpr\.org\/api\/assets|, body: AH_JSON[:asset], content_type: "application/json")
  end

  def self.register_kpcc_api
    FakeWeb.register_uri(:any, %r|scpr\.org\/api\/v2\/content|, 
      :content_type => "application/json", 
      :body         => File.read(Rails.root.join("spec/fixtures/scpr_content.json"))
    )
  end
end
