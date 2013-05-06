module Api::Public::V1
  class BucketsController < BaseController
    before_filter :sanitize_id, only: [:show]

    def index
      @buckets = Bucket.all
      respond_with @buckets
    end

    def show
      @bucket = Bucket.where(key: @id).first
      
      if !@bucket
        render_not_found and return false
      end

      respond_with @bucket
    end

    #---------------

    private

    def sanitize_id
      @id = params[:id].to_s
    end
  end
end
