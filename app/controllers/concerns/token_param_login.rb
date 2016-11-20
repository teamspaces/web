module TokenParamLogin
  extend ActiveSupport::Concern

  included do
    before_action :token_authentication_requested?
  end

  def token_authentication_requested?
    result = AuthorizeLoginWithToken.call(url: request.original_url)

    if result.success?
      sign_in result.user
      redirect_to result.url
    end
  end
end
