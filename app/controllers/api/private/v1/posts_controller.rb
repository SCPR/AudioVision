module Api::Private::V1
  class PostsController < BaseController
    
    before_filter \
      :sanitize_page, 
      :sanitize_limit, 
      :sanitize_query,
      :sanitize_category,
      only: [:index]

    before_filter :sanitize_url, only: [:by_url]
    before_filter :sanitize_id, only: [:show]
    
    #-------------------------
    # There is currently no reason for us to allow unpublished
    # posts to be found via the API. Once we need that capability,
    # we can change it here.
    def index
      @posts = Post.published.page(@page).per(@limit)
      
      if @query.present?
        @posts.where!("title like ?", "%#{@query}%")
      end

      if @category_slug.present?
        @posts = @posts.includes(:category)
          .where(Category.table_name => { slug: @category_slug })
      end

      respond_with @posts
    end

    #-------------------------

    # There is currently no reason for us to allow unpublished
    # posts to be found via the API. Once we need that capability,
    # we can change it here.
    def show
      @post = Post.published.where(id: @id).first

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

    #---------------------------

    def sanitize_category
      @category_slug = params[:category].to_s
    end
  end
end
