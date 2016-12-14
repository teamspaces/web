module RouteHelper
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::AssetUrlHelper

  protected
    def default_url_options
      Rails.application.config.action_mailer.default_url_options
    end
end
