class ReportersController < ApplicationController
  before_filter :set_nav_highlight

  def index
    @reporters = Reporter.where(is_listed: true)
  end

  def show
    @reporter = Reporter.includes(:posts).find_by_slug!(params[:slug])
    @posts = @reporter.posts.page(params[:page]).per(16)
  end


  private

  def set_nav_highlight
    @nav_highlight = "about"
  end
end
