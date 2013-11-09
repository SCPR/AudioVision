class User < ActiveRecord::Base
  outpost_model

  include Outpost::Model::Authorization
  include Outpost::Model::Authentication

  has_one :profile, class_name: "Reporter"
end
