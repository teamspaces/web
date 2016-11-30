class TeamAuthentications::CreateSlackAuthentication
  include Interactor

  attr_reader :team, :token, :scopes, :authentication

  def call
    @team = context.team
    @token = context.token
    @scopes = context.scopes

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
                           token: token)
  end

  def rollback
    authentication.destroy
  end
end
