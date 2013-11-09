require 'spec_helper'

describe Attribution do
  describe '::for_byline' do
    it "grabs attributions that belong in the byline and orders them by role" do
      source        = create :attribution, role: Attribution::ROLE_SOURCE
      contributor   = create :attribution, role: Attribution::ROLE_CONTRIBUTOR
      author        = create :attribution, role: Attribution::ROLE_AUTHOR

      Attribution.for_byline.to_a.should eq [author, source]
    end
  end


  describe '#display_name' do
    it "is the reporter name if available" do
      attribution = build :attribution, :with_reporter, name: "Dr. Farnsworth"
      attribution.display_name.should eq attribution.reporter.name
      attribution.display_name.should_not eq "Dr. Farnsworth"
    end

    it "is the passed-in name if no reporter is present" do
      attribution = build :attribution, :without_reporter, name: "Turanga Leela"
      attribution.display_name.should eq "Turanga Leela"
    end
  end


  describe '#display_url' do
    it 'prefers the passed-in url over the reporter URL' do
      attribution = build :attribution, :with_reporter, url: "http://kpcc.org"
      attribution.display_url.should eq "http://kpcc.org"
    end

    it 'uses the reporter url if available' do
      attribution = build :attribution, :with_reporter, url: nil
      attribution.display_url.should eq attribution.reporter.public_url
    end

    it 'is the passed in URL if no reporter is available' do
      attribution = build :attribution, :without_reporter, url: "http://scpr.org"
      attribution.display_url.should eq "http://scpr.org"
    end

    it 'is nothing if no URL and no reporter are available' do
      attribution = build :attribution, :without_reporter, url: nil
      attribution.display_url.should eq nil
    end
  end

  describe '#role_text' do
    it "returns the role text" do
      attribution = build :attribution, role: Attribution::ROLE_SOURCE
      attribution.role_text.should eq "Source"
    end
  end
end
