class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  STATE_PARAM = "state".freeze
  LOGIN_STATE = "login".freeze
  REGISTER_STATE = "register".freeze

  def slack_button
    team = Team.find(omniauth_params["team_id"])

    result = TeamAuthentication::CreateSlackAuthentication.call(team: team,
                                                                team_uid: slack_identity.team.id,
                                                                token: token,
                                                                scopes: [ "users:read",
                                                                          "chat:write:bot",
                                                                          "commands" ])
    if result.success?
      redirect_to previous_url
    else
      redirect_to previous_url, alert: t(".failed_to_save_team_authentication")
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
    result = User::FindUserWithSlackIdentity.call(slack_identity: slack_identity)

    if result.success?
      redirect_to user_sign_in_path(result.user)
    else
      redirect_to landing_path, alert: t(".failed_login_using_slack")
    end
  end

  def register_using_slack
    login_result = User::FindUserWithSlackIdentity.call(slack_identity: slack_identity)

    if login_result.success?

      redirect_to user_sign_in_path(login_result.user), alert: t(".register_failed_as_user_already_exists")
    else
      result = User::CreateUserFromSlackIdentity.call(slack_identity: slack_identity, token: token)

      if result.success?
        redirect_to user_sign_in_path(result.user)
      else
        redirect_to landing_path, alert: t(".failed_register_using_slack")
      end
    end
  end

  private

    def slack_identity
      request.env["omniauth.auth"].extra.identity
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

    def previous_url
      request.env['omniauth.origin']
    end
end
