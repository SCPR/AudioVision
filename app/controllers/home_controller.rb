class HomeController < ApplicationController
  FakeBillboard = Struct.new(:layout)

  def homepage
    @nav_highlight = "home"
    @billboard = FakeBillboard.new(params[:layout] || "1")
  end
end
