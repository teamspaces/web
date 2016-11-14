class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def slack
    if slack_identity_fetched?
      register_or_login_using_slack
    else
      redirect_to_standard_auth
    end
  end

  def register_or_login_using_slack
    user = login_using_slack || register_using_slack

    if user
      sign_in user
      redirect_to_team_path
    else
      redirect_to_standard_auth
    end
  end

  def login_using_slack
    login_form = User::SlackLoginForm.new(slack_identity: slack_identity)
    return login_form.user if login_form.authenticate
  end

  def register_using_slack
    register_form = User::SlackRegisterForm.new(slack_identity: slack_identity)
    return register_form.user if register_form.save
  end

  def redirect_to_team_path
    path = current_user.teams.any? ? teams_path : new_team_path

    redirect_to path
  end

  def redirect_to_standard_auth
    logger.error "failed to fetch user from slack, redirecting"

    redirect_to sign_up_path,
                alert: t(".failed_to_fetch_user_from_slack") and return
  end

  private

    def token_secret
      omniauth_auth["credentials"]["token"]
    end

    def slack_identity
      @slack_identity ||= fetch_slack_identity(token_secret)
    end

    def slack_identity_fetched?
      slack_identity&.success?
    end

    def fetch_slack_identity(token)
      identity = Slack::Identity.new(token)
      identity.fetch and identity
    rescue Faraday::Error => e
      logger.error("failed to fetch slack identity: #{e.message}")
      logger.error e.backtrace.join("\n")

      return false
    end

    def omniauth_auth
      request.env["omniauth.auth"]
    end

    def omniauth_params
      request.env["omniauth.params"]
    end
end
