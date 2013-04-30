class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Outpost::Controller::CustomErrors

  def render_error(status, e=StandardError)
    super
    report_error(e)
  end
end
