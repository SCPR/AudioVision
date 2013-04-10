module Api::Public::V1
  class PostsController < BaseController
    respond_to :json

    def index
      @posts = Post.published
      respond_with @posts
    end

    def show
      @post = Post.find(params[:id])
      respond_with @post
    end
  end
end
