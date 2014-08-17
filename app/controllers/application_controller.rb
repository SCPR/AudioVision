class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Outpost::Controller::CustomErrors

  # This is here just to set the template_prefix option.
  def render_error(status, e=StandardError, template_prefix="")
    super
  end
end
