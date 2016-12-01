class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :fetch_slack_identity, only: :slack

  STATE_PARAM = "state".freeze
  LOGIN_STATE = "login".freeze
  REGISTER_STATE = "register".freeze

  def slack_button
    team = current_user.teams.find(omniauth_params["team_id"])

    result = TeamAuthentication::CreateSlackAuthentication.call(team: team,
                                                                token: token,
                                                                scopes: [ "users:read",
                                                                          "chat:write:bot",
                                                                          "commands"])
    if result.success?
      redirect_to request.env['omniauth.origin']
    else
      redirect_to request.env['omniauth.origin'], alert: t(".failed_to_save_team_authentication")
    end
  end

  def slack
    if login_request?
      login_using_slack
    elsif register_request?
      register_using_slack
    else
      render status: :unprocessable_entity, plain: "Missing parameter: #{STATE_PARAM}"
    end
  end

  def login_using_slack
    result = User::FindUserWithSlackIdentity.call(slack_identity: @slack_identity)

    if result.success?

      sign_in(result.user)
      redirect_to after_sign_in_path_for(result.user)
    else
      redirect_to new_user_session_path, alert: t(".failed_login_using_slack")
    end
  end

  def register_using_slack
    login_result = User::FindUserWithSlackIdentity.call(slack_identity: @slack_identity)

    if login_result.success?

      sign_in(login_result.user)
      redirect_to after_sign_in_path_for(login_result.user), alert: t(".register_failed_as_user_already_exists")
    else
      result = User::CreateUserFromSlackIdentity.call(slack_identity: @slack_identity, token: token)

      if result.success?

        sign_in(result.user)
        redirect_to after_sign_in_path_for(result.user)
      else
        redirect_to register_path, alert: t(".failed_register_using_slack")
      end
    end
  end

  private

    def fetch_slack_identity
      result = Slack::FetchIdentity.call(token: token)

      if result.success?
        @slack_identity = result.slack_identity
      else
        redirect_back(fallback_location: landing_url, alert: t(".failed_to_fetch_slack_identity")) and return
      end
    end

    def login_request?
      omniauth_params[STATE_PARAM] == LOGIN_STATE
    end

    def register_request?
      omniauth_params[STATE_PARAM] == REGISTER_STATE
    end

    def token
      request.env["omniauth.auth"]["credentials"]["token"]
    end

    def omniauth_params
      request.env["omniauth.params"]
    end
end
