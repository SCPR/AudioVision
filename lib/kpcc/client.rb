module Kpcc
  class Client

    def get(path, params={})
      begin
        connection.get do |request|
          request.url path
          request.params = params
          request.options[:timeout]      = 10
          request.options[:open_timeout] = 10
        end
      rescue Faraday::Error::TimeoutError
        nil
      end
    end


    private

    def connection
      @connection ||= begin
        Faraday.new(url: api_root) do |conn|
          conn.response :json
          conn.adapter Faraday.default_adapter
        end
      end
    end

    def api_root
      @api_root ||= Rails.application.config.scpr.host + Rails.application.config.scpr.api_path
    end
  end
end
