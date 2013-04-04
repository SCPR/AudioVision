class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Outpost::Controller::CustomErrors

  def render_error(status, e=StandardError)
    if Rails.application.config.consider_all_requests_local
      raise e
    else
      respond_to do |format|
        format.html { render template: "/errors/error_#{status}", status: status, locals: { error: e } }
        format.xml { render xml: { error: status.to_s }, status: status }
        format.text { render text: status, status: status}
      end
      
      report_error(e)
    end
  end
end
