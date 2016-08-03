class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  STATE_PARAM = "state".freeze
  LOGIN_STATE = "login".freeze
  REGISTER_STATE = "register".freeze

  def slack
    if login_request?
      login_using_slack and return
    elsif register_request?
      register_using_slack and return
    end

    render status: :unprocessable_entity,
           plain: "Missing parameter: #{STATE_PARAM}"
  end

  def failure
    redirect_to root_path
  end

  def login_using_slack
    login_form = User::SlackLoginForm.new(uid: uid)
    if login_form.login
      login_and_redirect(login_form.user)
    else
      redirect_to new_user_session_path, alert: login_form.errors.full_messages
    end
  end

  def register_using_slack
    login_form = User::SlackLoginForm.new(uid: uid)
    if login_form.login
      login_and_redirect(login_form.user)
      redirect_to choose_team_path and return
    end

    register_form = User::SlackRegisterForm.new(token_secret: token_secret)
    if register_form.save
      redirect_to create_team_path
    else
      redirect_to register_path, alert: t(".failed_register_using_slack") # TODO: Use error from the form instead?
    end
  end

  private

    def login_and_redirect(user)
      # Passing `event` causes Warden to trigger the hook `after_authentication`
      sign_in_and_redirect(user, event: :authentication)
    end

    def login_request?
      omniauth_params[STATE_PARAM] == LOGIN_STATE
    end

    def register_request?
      omniauth_params[STATE_PARAM] == REGISTER_STATE
    end

    def uid
      omniauth_auth.uid
    end

    def token_secret
      omniauth_auth.credentials.token
    end

    def omniauth_auth
      request.env["omniauth.auth"]
    end

    def omniauth_params
      request.env["omniauth.params"]
    end
end
