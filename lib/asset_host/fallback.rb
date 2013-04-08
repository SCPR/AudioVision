module AssetHost
  class Fallback < Asset
    def self.logger
      @logger ||= Logger.new(Rails.root.join("log/asset-fallback.log"))
    end

    def self.log(response, id)
      logger.info "*** [#{Time.now}] AssetHost returned #{response} for Asset ##{id}"
    end

    def initialize
      json = JSON.parse(File.read(File.join(File.dirname(__FILE__), "fallback", "asset_fallback.json")))
      super(json)
    end
  end
end
