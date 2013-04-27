require 'spec_helper'

describe Outpost::ReportersController do
  before :each do
    user = create :user
    controller.stub(:current_user) { user }
  end
end
