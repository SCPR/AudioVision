require 'spec_helper'

describe ApplicationHelper do
  describe '#nav_link' do
    it 'has the "selected" class if the passed-in key matches @nav_highlight' do
      @nav_highlight = "bender"
      link = helper.nav_link("Bite", "/my/shiny/metal", key: "bender")
      link.should match /selected/
    end

    it "doesn't have the selected class if keys don't match" do
      link = helper.nav_link("Bite", "/my/shiny/metal", key: "fry")
      link.should_not match /selected/
    end
  end


  describe '#render_byline' do
    let(:post) { create :post }

    it "includes only authors and sources" do
      author        = create :attribution, post: post, role: Attribution::ROLE_AUTHOR, name: "Leela"
      contributor   = create :attribution, post: post, role: Attribution::ROLE_CONTRIBUTOR, name: "Bender"
      source        = create :attribution, post: post, role: Attribution::ROLE_SOURCE, name: "Fry"

      rendered = helper.render_byline(post)
      rendered.should match /Fry/
      rendered.should match /Leela/
      rendered.should_not match /Bender/
    end
  end


  describe '#byline_elements' do
    it "makes it a link if the URL is present" do
      attribution = build :attribution, :without_reporter, url: "http://marsu.edu",role: Attribution::ROLE_AUTHOR

      array = helper.byline_elements(attribution)
      array.first.should match /<a href/
      array.first.should match /marsu\.edu/
    end

    it "is not a link if no URL present" do
      attribution = build :attribution, name: "Amy", role: Attribution::ROLE_AUTHOR

      array = helper.byline_elements(attribution)
      array.first.should_not match /<a href/
    end

    it "takes multiple attributions too!" do
      attributions = build_list :attribution, 2, :without_reporter
      helper.byline_elements(attributions).size.should eq 2
    end
  end
end
