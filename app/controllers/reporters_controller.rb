class ReportersController < ApplicationController
  before_filter :set_nav_highlight

  def index
    @reporters = Reporter.all
  end

  def show
    @reporter = Reporter.find_by_slug!(params[:slug])
  end


  private

  def set_nav_highlight
    @nav_highlight = "about"
  end
end
