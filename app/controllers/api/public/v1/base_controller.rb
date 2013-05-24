module Api::Public::V1
  VERSION   = Gem::Version.new("1.4.1")
  TYPE      = "public"

  class BaseController < ::ActionController::Base
    respond_to :json


    private

    #---------------------------

    def render_not_found(options={})
      message = options[:message] || "Not Found"
      render status: :not_found, json: { error: message }
    end

    #---------------------------

    def render_bad_request(options={})
      message = options[:message] || "Bad Request"
      render status: :bad_request, json: { error: message }
    end

    #---------------------------

    def render_unauthorized(options={})
      message = options[:message] || "Unauthorized"
      render status: :unauthorized, json: { error: message }
    end
  end
end
