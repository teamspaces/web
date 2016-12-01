class TeamAuthentication::CreateSlackAuthentication
  include Interactor

  attr_reader :team, :token, :scopes

  def call
    @team = context.team
    @token = context.token
    @scopes = context.scopes

    authentication = build_authentication
    if authentication.save
      context.authentication = authentication
    else
      Rails.logger.error "TeamAuthentications::CreateSlackAuthentication#call failed with team.id=#{team.id} token=#{token} scopes=#{scopes}"

      context.fail!
    end
  end

  def build_authentication
    authentication = TeamAuthentication.first_or_initialize(provider: :slack,
                                                            team: team)

    authentication.scopes = scopes
    authentication.token = token

    authentication
  end

  def rollback
    authentication.destroy
  end
end
