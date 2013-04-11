module Api::Public::V1
  class PostsController < BaseController
    respond_to :json

    def index
      @posts = Post.published.page(params[:page]).per(params[:limit])
      
      if params[:query].present?
        @posts = @posts.where("title like ?", "%#{params[:query]}%")
      end

      respond_with @posts.map { |post| post_json(post) }
    end

    def show
      @post = Post.find(params[:id])
      respond_with post_json(@post)
    end

    def by_url
      @post = Post.by_url(params[:url])
      respond_with post_json(@post)
    end

    private

    def post_json(post)
      {
        :id           => post.obj_key,
        :title        => post.to_title,
        :published_at => post.published_at,
        :teaser       => post.teaser.html_safe,
        :body         => post.body.html_safe,
        :permalink    => post.remote_link_path,
        :asset        => post.asset.lsquare.tag,
        :byline       => post.byline,
        :edit_link    => post.admin_edit_path
      }
    end
  end
end
