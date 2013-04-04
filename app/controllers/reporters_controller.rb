class ReportersController < ApplicationController
  def index
    @reporters = Reporter.all
  end

  def show
    @reporter = Reporter.find_by_slug!(params[:slug])
  end
end
