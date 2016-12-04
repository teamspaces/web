class TeamAuthentication::CreateSlackAuthentication
  include Interactor

  attr_reader :team, :token, :scopes

  def call
    @team = context.team
    @token = context.token
    @scopes = context.scopes

    team_authentication = build_team_authentication
    if team_authentication.save
      context.team_authentication = team_authentication
    else
      Rails.logger.error "TeamAuthentications::CreateSlackAuthentication#call failed with team.id=#{team.id} token=#{token} scopes=#{scopes}"

      context.fail!
    end
  end

  def build_team_authentication
    authentication = TeamAuthentication.find_or_initialize_by(provider: :slack,
                                                              team: team)

    authentication.scopes = scopes
    authentication.token = token

    authentication
  end
end
