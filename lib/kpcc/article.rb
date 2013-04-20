module Kpcc
  class Article

    class << self
      def find(obj_key)
        response = client.get("content/#{obj_key}")
        
        if response.success?
          new(response.body)
        else
          raise ActiveRecord::RecordNotFound
        end
      end

      def find_by_url(url)
        response = client.get("content/by_url", url: url)
        
        if response.success?
          new(response.body)
        else
          nil
        end
      end


      private

      def client
        @client ||= Kpcc::Client.new
      end
    end




    ATTRIBUTES = [:id, :title, :short_title, :teaser, 
    :body, :published_at, :thumbnail, :byline, :permalink]

    attr_accessor *ATTRIBUTES

    def initialize(attributes={})
      @id           = attributes["id"]
      @title        = attributes["title"]
      @short_title  = attributes["short_title"]
      @teaser       = attributes["teaser"]
      @body         = attributes["body"]
      @thumbnail    = attributes["thumbnail"]
      @byline       = attributes["byline"]
      @permalink    = attributes["permalink"]
      @published_at = Time.parse(attributes["published_at"])
    end
  end
end
