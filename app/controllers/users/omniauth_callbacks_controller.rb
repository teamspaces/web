class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def slack
    result = Slack::FetchIdentity.call(token: token)

    if result.success?
      login(result.slack_identity) ||
      register(result.slack_identity) ||
      redirect_back(fallback_location: landing_url, alert: t(".failed_to_login_or_register_using_slack"))
    else
      redirect_back(fallback_location: landing_url, alert: t(".failed_to_login_or_register_using_slack"))
    end
  end

  def login(slack_identity)
    result = User::FindUserWithSlackIdentity.call(slack_identity: slack_identity)
    if result.success?
      sign_in(result.user)
      redirect_to after_sign_in_path_for(result.user)
      return true
    end

    false
  end

  def register(slack_identity)
    result = User::CreateUserFromSlackIdentity.call(slack_identity: slack_identity, token: token)
    if result.success?
      sign_in(result.user)
      redirect_to after_sign_in_path_for(result.user)
      return true
    end

    false
  end

  private

    def token
      request.env["omniauth.auth"]["credentials"]["token"]
    end
end
