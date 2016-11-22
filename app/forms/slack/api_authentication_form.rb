class Slack::ApiAuthenticationForm
  include Inflorm

  attribute :user, User
  attribute :token, String
  attribute :scopes, Array

  validates :user, :token, :scopes, presence: true

  private

    def persist!
      Authentication.create(provider: :slack_api,
                            user: user,
                            scopes: scopes,
                            token: token)
    end
end
