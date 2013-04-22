module Api::Private::V1
  class PostsController < BaseController
    before_filter :sanitize_page, 
      :sanitize_limit, 
      :sanitize_query,
      only: [:index]

    before_filter :sanitize_url, only: [:by_url]
    before_filter :sanitize_id, only: [:show]
    
    #-------------------------

    def index
      @posts = Post.published.page(@page).per(@limit)
      
      if @query.present?
        @posts = @posts.where("title like ?", "%#{@query}%")
      end

      respond_with @posts
    end

    #-------------------------

    def show
      @post = Post.where(id: @id)

      if !@post
        render_not_found and return false
      end

      respond_with @post
    end

    #-------------------------

    def by_url
      @post = Post.find_by_url(@url)
      
      if !@post
        render_not_found and return false
      end

      respond_with @post do |format|
        format.json { render :show }
      end
    end


    #-------------------------

    private

    def sanitize_url
      begin
        # Parse the URI and then turn it back into a string,
        # just to make sure it's even a valid URI before we pass
        # it on.
        @url = URI.parse(params[:url]).to_s
      rescue URI::Error
        render_bad_request(message: "Invalid URL") and return false
      end
    end

    #---------------------------

    def sanitize_id
      @id = params[:id].to_i
    end

    #---------------------------
    # No limit for Private API
    def sanitize_limit
      @limit = params[:limit] ? params[:limit].to_i : 10
    end

    #---------------------------
    
    def sanitize_page
      page = params[:page].to_i
      @page = page > 0 ? page : 1
    end
    
    #---------------------------
    
    def sanitize_query
      @query = params[:query].to_s
    end
  end
end
