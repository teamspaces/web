class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  STATE_PARAM = "state".freeze
  LOGIN_STATE = "login".freeze
  REGISTER_STATE = "register".freeze

  def slack
    if login_request?
      login_using_slack
    elsif register_request?
      register_using_slack
    else
      render status: :unprocessable_entity,
             plain: "Missing parameter: #{STATE_PARAM}"
    end
  end

  def failure
    logger.error "callback failure, redirecting"
    redirect_to root_path
  end

  def login_using_slack
    logger.info "login user with slack initiated"

    unless slack_identity&.success?
      logger.error "failed to fetch user from slack, redirecting"
      redirect_to new_user_session_path,
                  alert: t(".failed_to_fetch_user_from_slack") and return
    end

    login_form = User::SlackLoginForm.new(slack_identity: slack_identity)
    if login_form.authenticate
      logger.info "successful authentication, signing in and redirecting"
      sign_in login_form.user
      redirect_to teams_path
    else
      logger.error "failed authentication, redirecting"
      redirect_to new_user_session_path,
                  alert: t(".failed_login_using_slack")
    end
  end

  def register_using_slack
    logger.info "register user with slack initiated"

    unless slack_identity&.success?
      logger.error "failed to fetch user from slack, redirecting"
      redirect_to register_path,
                  alert: t(".failed_to_fetch_user_from_slack") and return
    end

    debugger
    login_form = User::SlackLoginForm.new(slack_identity: slack_identity)
    if login_form.authenticate
      logger.info "user already registered, login instead"
      sign_in login_form.user
      redirect_to teams_path,
                  alert: t(".register_failed_as_user_already_exists")
    else
      register_form = User::SlackRegisterForm.new(slack_identity: slack_identity)
      if register_form.save
        logger.info "user registered successfully, redirecting"
        sign_in register_form.user
        redirect_to new_team_path
      else
        logger.error "failed to register, redirecting"
        redirect_to register_path,
                    alert: t(".failed_register_using_slack")
      end
    end
  end

  private

    def token_secret
      omniauth_auth["credentials"]["token"]
    end

    def slack_identity
      @slack_identity ||= fetch_slack_identity(token_secret)
    end

    def fetch_slack_identity(token)
      identity = Slack::Identity.new(token)
      identity.fetch and identity
    rescue Faraday::Error => e
      logger.error("failed to fetch slack identity: #{e.message}")
      logger.error e.backtrace.join("\n")

      return false
    end

    def login_request?
      omniauth_params[STATE_PARAM] == LOGIN_STATE
    end

    def register_request?
      omniauth_params[STATE_PARAM] == REGISTER_STATE
    end

    def omniauth_auth
      request.env["omniauth.auth"]
    end

    def omniauth_params
      request.env["omniauth.params"]
    end
end
