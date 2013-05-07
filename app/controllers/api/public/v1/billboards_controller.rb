module Api::Public::V1
  class BillboardsController < BaseController
    before_filter :sanitize_id, only: [:show]

    def index
      @billboards = Billboard.published
      respond_with @billboards
    end

    #---------------

    def show
      @billboard = Billboard.published.where(id: @id).first
      
      if !@billboard
        render_not_found and return false
      end

      respond_with @billboard
    end

    #---------------

    def current
      @billboard = Billboard.published.first

      if !@billboard
        render_not_found and return false
      end

      respond_with @billboard do |format|
        format.json { render :show }
      end
    end

    #---------------

    private

    def sanitize_id
      @id = params[:id].to_s
    end
  end
end
