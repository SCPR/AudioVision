require 'spec_helper'

describe Outpost::BucketsController do
  before :each do
    user = create :user
    controller.stub(:current_user) { user }
    user.permissions << Permission.find_by_resource("Bucket")
  end
end
