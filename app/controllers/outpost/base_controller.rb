class Outpost::BaseController < Outpost::ApplicationController
  def render_error(status, e=StandardError)
    super
    report_error(e)
  end
end
