class Outpost::BaseController < Outpost::ApplicationController
  def render_error(status, e=StandardError)
    if Rails.application.config.consider_all_requests_local
      raise e
    else
      render template: "/outpost/errors/error_#{status}", status: status, locals: { error: e }
      report_error(e)
    end
  end
end
