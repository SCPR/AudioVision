Outpost::Config.configure do |config|
  config.registered_models = [
    "Category",
    "Post",
    "Reporter",
    "User",
    "Billboard",
    "Bucket"
  ]

  config.authentication_attribute   = :username
  config.title_attributes           = [:title, :name]
  config.excluded_form_fields       = []
  config.excluded_list_columns      = ["body"]
end

module Outpost
  module Controller
    module CustomErrors
      def report_error(e)
        ::NewRelic.log_error(e)
      end
    end
  end
end
