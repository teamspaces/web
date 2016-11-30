class TeamAuthentications::CreateSlackAuthentication
  include Interactor

  attr_reader :team, :token, :scopes, :slack_authentication_info, :authentication

  def call
    @team = context.team
    @token = context.token
    @scopes = context.scopes
    @slack_authentication_info = context.slack_authentication_info

    @authentication = build_authentication
    if authentication.save
      context.authentication = authentication
    else
      context.fail!
    end
  end

  def build_authentication
    TeamAuthentication.new(provider: :slack,
                           team: team,
                           scopes: scopes,
                           token: token,
                           foreign_team_id: slack_authentication_info.team_id,
                           foreign_user_id: slack_authentication_info.user_id)
  end

  def rollback
    authentication.destroy
  end
end
