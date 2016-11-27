class Slack::ApiAuthenticationForm
  include Inflorm

  attribute :team, Team
  attribute :token, String
  attribute :scopes, Array

  validates :team, :token, :scopes, presence: true

  private

    def persist!
      TeamAuthentication.create(provider: :slack_api,
                                team: team,
                                scopes: scopes,
                                token: token)
    end
end
