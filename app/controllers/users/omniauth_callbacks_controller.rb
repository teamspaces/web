class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def slack
    if slack_identity_fetched?
      if upon_invitation? && !invitation_matches_slack_identity?
        redirect_back_and_show_slack_invitation_inconsistency
      else
        register_or_login_using_slack do |user|
          if upon_invitation?
            AcceptInvitation.call(user: user, token: invitation_from_token_param)
          end
        end
      end
    else
      redirect_to_standard_auth
    end
  end

  def register_or_login_using_slack
    user = login_using_slack || register_using_slack

    if user
      yield user if block_given?
      sign_in user
      redirect_to after_sign_in_path_for(user)
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

  def redirect_to_standard_auth
    logger.error "failed to fetch user from slack, redirecting"

    redirect_to sign_up_path,
                alert: t(".failed_to_fetch_user_from_slack") and return
  end

  private

    def upon_invitation?
      omniauth_params["invitation_token"].present? && invitation_from_token_param
    end

    def invitation_from_token_param
       Invitation.find_by(token: omniauth_params["invitation_token"])
    end

    def invitation_matches_slack_identity?
      invitation = invitation_from_token_param
      if invitation.slack_id
        slack_identity.id == invitation.slack_id
      else
        slack_identity.email == invitation.email
      end
    end

    def redirect_back_and_show_slack_invitation_inconsistency
      flash[:notice] = t(:invitation_does_not_match_slack_account)
      redirect_back(fallback_location: landing_path)
    end

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
