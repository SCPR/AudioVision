Outpost::Config.configure do |config|
  config.registered_models = [
    "Post",
    "Flatpage",
    "Reporter",
    "User"
  ]
  
  config.authentication_attribute   = :username
  config.title_attributes           = [:title, :name]
  config.excluded_form_fields       = []
  config.excluded_list_columns      = ["body"]
end
