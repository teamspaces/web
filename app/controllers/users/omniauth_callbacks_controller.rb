class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def slack_invitation
    result = LoginOrRegisterWithSlackUponInvitation.call(token: token, invitation_token: invitation_token)

    if result.success?
      sign_in(result.user)
      redirect_to after_sign_in_path_for(result.user)
    else
      redirect_back(fallback_location: landing_url, alert: t(".invitation_does_not_match_slack_user"))
    end
  end

  def slack
    result = LoginOrRegisterWithSlack.call(token: token)

    if result.success?
      sign_in(result.user)
      redirect_to after_sign_in_path_for(result.user)
    else
      redirect_back(fallback_location: landing_url, alert: t(".failed_to_login_register_with_slack"))
    end
  end

  private

    def token
      request.env["omniauth.auth"]["credentials"]["token"]
    end

    def invitation_token
      request.env["omniauth.params"]["invitation_token"]
    end
end
