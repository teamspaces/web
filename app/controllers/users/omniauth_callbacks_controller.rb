class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def slack
    result = FindOrCreateUserWithSlack.call(token: token)

    debugger

    if result.success?
      sign_in(result.user)
      redirect_to after_sign_in_path_for(result.user)
    else
      redirect_back(fallback_location: landing_url, alert: t(".failed_to_login_or_register_using_slack"))
    end
  end

  private

    def token
      request.env["omniauth.auth"]["credentials"]["token"]
    end
end
