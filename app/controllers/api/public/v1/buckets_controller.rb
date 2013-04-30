module Api::Public::V1
  class BucketsController < BaseController
    before_filter :sanitize_id, only: [:show]

    def index
      @buckets = Bucket.all
      respond_with @buckets
    end

    def show
      @bucket = Bucket.find_by_key(@id)
      respond_with @bucket
    end

    #---------------

    private

    def sanitize_id
      @id = params[:id].to_s
    end
  end
end
