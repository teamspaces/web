class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  STATE_PARAM = "state".freeze
  LOGIN_STATE = "login".freeze
  REGISTER_STATE = "register".freeze

  def slack
    result = Slack::FetchIdentity.call(token: token)

    if result.success?

      if login_request?
        login_using_slack(result.slack_identity)
      elsif register_request?
        register_using_slack(result.slack_identity)
      else
        render status: :unprocessable_entity, plain: "Missing parameter: #{STATE_PARAM}"
      end
    else
      redirect_back(fallback_location: landing_url, alert: t(".failed_to_fetch_slack_identity"))
    end
  end

  def login_using_slack(slack_identity)
    result = User::FindUserWithSlackIdentity.call(slack_identity: slack_identity)

    if result.success?
      logger.info "successful authentication, signing in and redirecting"

      sign_in(result.user)
      redirect_to after_sign_in_path_for(result.user)
    else
      logger.error "failed authentication, redirecting"
      redirect_to new_user_session_path, alert: t(".failed_login_using_slack")
    end
  end

  def register_using_slack(slack_identity)
    login_result = User::FindUserWithSlackIdentity.call(slack_identity: slack_identity)

    if login_result.success?
      logger.info "user already registered, login instead"

      sign_in(login_result.user)
      redirect_to after_sign_in_path_for(login_result.user), alert: t(".register_failed_as_user_already_exists")
    else
      result = User::CreateUserFromSlackIdentity.call(slack_identity: slack_identity, token: token)

      if result.success?
        logger.info "user registered successfully, redirecting"

        sign_in(result.user)
        redirect_to after_sign_in_path_for(result.user)
      else
        logger.error "failed to register, redirecting"
        redirect_to register_path, alert: t(".failed_register_using_slack")
      end
    end
  end

  private

    def login_request?
      request.env["omniauth.params"][STATE_PARAM] == LOGIN_STATE
    end

    def register_request?
      request.env["omniauth.params"][STATE_PARAM] == REGISTER_STATE
    end

    def token
      request.env["omniauth.auth"]["credentials"]["token"]
    end
end
