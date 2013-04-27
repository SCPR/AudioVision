require 'spec_helper'

describe Outpost::UsersController do
  before :each do
    user = create :user
    controller.stub(:current_user) { user }
  end
end
