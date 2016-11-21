module TokenParamLogin
  extend ActiveSupport::Concern

  included do
    before_action :token_authentication_requested?
  end

  def token_authentication_requested?
    result = AuthorizeLoginWithToken.call(auth_token: params[:auth_token])

    if result.success?
      sign_in result.user
      redirect_to url_for(params.except(:auth_token))
    end
  end
end
