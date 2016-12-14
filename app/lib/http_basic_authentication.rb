module HTTPBasicAuthentication
  extend ActiveSupport::Concern
  included do
    if ENV["ENABLE_BASIC_AUTH"] == "true"
      http_basic_authenticate_with name: ENV["BASIC_AUTH_USERNAME"],
                                   password: ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end
