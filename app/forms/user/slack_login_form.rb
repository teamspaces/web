class User::SlackLoginForm
  include Inflorm

  attr_reader :authentication

  attribute :slack_identity, Slack::Identity
  validates :slack_identity, presence: true

  def authenticate
    !!find_authentication
  end

  def user
    authentication&.user
  end

  private

    def find_authentication
      @authentication = Authentication.find_by(provider: :slack,
                                               uid: slack_identity.uid)
    end
end
