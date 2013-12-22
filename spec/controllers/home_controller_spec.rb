require 'spec_helper'

describe HomeController do
  describe 'GET homepage' do
    render_views

    let(:slideshow_post) { create :post, post_type: Post::POST_TYPES[:slideshow] }
    let(:image_post)     { create :post, post_type: Post::POST_TYPES[:image] }
    let(:mobile_post)    { create :post, post_type: Post::POST_TYPES[:gallery] }
    let(:video_post)     { create :post, post_type: Post::POST_TYPES[:video] }

    it "gets the most recently published billboard" do
      billboard1 = create :billboard, published_at: 1.day.ago
      billboard2 = create :billboard, published_at: 1.day.from_now
      billboard3 = create :billboard, status: Billboard::STATUS[:draft], published_at: 5.days.from_now

      get :homepage
      assigns(:billboard).should eq billboard2
    end

    it "renders some recent posts" do
      published_posts     = create_list :post, 1
      unpublished_posts   = create_list :post, 1, status: Post::STATUS[:draft]

      get :homepage
      assigns(:recent_posts).to_a.should eq published_posts
    end

    it "doesn't include any posts from the billboard in the recent posts" do
      billboard       = create :billboard
      billboard_post  = create :post
      other_posts     = create_list :post, 2

      get :homepage
      recent_posts = assigns(:recent_posts).to_a
      recent_posts.should include billboard_post
      recent_posts.size.should eq 3

      billboard.posts << billboard_post

      get :homepage
      recent_posts = assigns(:recent_posts).to_a
      recent_posts.should_not include billboard_post
      recent_posts.size.should eq 2
    end

    it "assigns the buckets matching the requested keys" do
      midway_bucket = create :bucket, key: HomeController::MIDWAY_BUCKET_KEY
      right_bar_bucket = create :bucket, key: HomeController::RIGHT_BAR_BUCKET_KEY

      get :homepage
      assigns(:midway_bucket).should eq midway_bucket
      assigns(:right_bar_bucket).should eq right_bar_bucket
    end


    context 'with layout_1' do
      it "renders properly" do
        billboard = create :billboard, layout: 1
        billboard.posts = [slideshow_post, video_post, mobile_post]

        get :homepage
        response.should render_template(partial: "billboards/_layout_1")
        response.should render_template(partial: "billboards/components/_slideshow")
        response.should render_template(partial: "billboards/components/_video")
        response.should render_template(partial: "billboards/components/_mobile")
      end
    end

    context 'with layout_2' do
      it "renders properly" do
        billboard = create :billboard, layout: 2
        billboard.posts = [slideshow_post, image_post, image_post, image_post]

        get :homepage
        response.should render_template(partial: "billboards/_layout_2")
        response.should render_template(partial: "billboards/components/_slideshow")
        response.should render_template(partial: "billboards/components/_image")
      end
    end

    context 'with layout_3' do
      it "renders properly" do
        billboard = create :billboard, layout: 3
        billboard.posts = [slideshow_post, video_post, video_post]

        get :homepage
        response.should render_template(partial: "billboards/_layout_3")
        response.should render_template(partial: "billboards/components/_slideshow")
        response.should render_template(partial: "billboards/components/_video")
      end
    end

    context 'with layout_4' do
      it "renders properly" do
        billboard = create :billboard, layout: 4
        billboard.posts = [video_post, mobile_post, image_post]

        get :homepage
        response.should render_template(partial: "billboards/_layout_4")
        response.should render_template(partial: "billboards/components/_video")
        response.should render_template(partial: "billboards/components/_mobile")
        response.should render_template(partial: "billboards/components/_image")
      end
    end

    context 'with layout_5' do
      it "renders properly" do
        billboard = create :billboard, layout: 5
        billboard.posts = [mobile_post, video_post, image_post, image_post, image_post]

        get :homepage
        response.should render_template(partial: "billboards/_layout_5")
        response.should render_template(partial: "billboards/components/_video")
        response.should render_template(partial: "billboards/components/_mobile")
        response.should render_template(partial: "billboards/components/_image")
      end
    end

    context 'with layout_6' do
      it "renders properly" do
        billboard = create :billboard, layout: 6
        billboard.posts = [mobile_post, image_post, video_post, video_post]

        get :homepage
        response.should render_template(partial: "billboards/_layout_6")
        response.should render_template(partial: "billboards/components/_mobile")
        response.should render_template(partial: "billboards/components/_image")
        response.should render_template(partial: "billboards/components/_video")
      end
    end

    context 'with layout_7' do
      it "renders properly" do
        billboard = create :billboard, layout: 7
        billboard.posts = [image_post, mobile_post, video_post, video_post]

        get :homepage
        response.should render_template(partial: "billboards/_layout_7")
        response.should render_template(partial: "billboards/components/_image")
        response.should render_template(partial: "billboards/components/_mobile")
        response.should render_template(partial: "billboards/components/_video")
      end
    end

    context 'with layout_8' do
      it "renders properly" do
        billboard = create :billboard, layout: 8
        billboard.posts = [video_post]

        get :homepage
        response.should render_template(partial: "billboards/_layout_8")
        response.should render_template(partial: "billboards/components/_episode")
      end
    end
  end
end
