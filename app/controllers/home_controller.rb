class HomeController < ApplicationController
  FakeBillboard = Struct.new(:layout)

  def homepage
    @billboard = FakeBillboard.new(params[:layout] || "1")
  end
end
