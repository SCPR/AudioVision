class User < ActiveRecord::Base
  establish_connection "mercer_#{Rails.env}"
  self.table_name = "auth_user"
  
  include Outpost::Model::Authorization
  include Outpost::Model::Authentication

  has_one :profile, class_name: "Reporter"
end
