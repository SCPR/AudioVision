module Api::Public::V1
  class PostsController < BaseController
    respond_to :json

    def index
      @posts = Post.published.page(params[:page]).per(params[:limit])
      
      if params[:query].present?
        @posts = @posts.where("title like ?", "%#{params[:query]}%")
      end

      respond_with @posts
    end


    def show
      @post = Post.published.find(params[:id])
      respond_with @post
    end


    def by_url
      @post = Post.by_url(params[:url])
      
      respond_with @post do |format|
        format.json { render :show }
      end
    end
  end
end
