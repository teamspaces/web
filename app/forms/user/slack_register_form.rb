class User::SlackRegisterForm
  include Inflorm

  attr_reader :token_secret,
              :authentication,
              :slack_identity,
              :generated_password

  attribute :token_secret, String
  validates :token_secret, presence: true

  private

    def persist!
      find_user_on_slack &&
        create_user &&
        create_authentication &&
        create_team
    end

    def find_user_on_slack
      begin
        @slack_identity = Slack::Identity.new(token_secret)
        slack_identity.fetch
      rescue Faraday::Error => e
        Rails.logger
        logger.error("User::SlackRegisterForm#find_user_on_slack: #{e.message}")
        logger.error e.backtrace.join("\n")
        return false
      end

      slack_identity.success?
    end

    def create_user
      user_attributes = { name: slack_user["name"],
                          email: slack_user["email"],
                          password: generated_password }

      @user = User.create(user_attributes)

      user.persisted?
    end

    def create_authentication
      authentication_attributes = { provider: :slack,
                                    uid: slack_identity.uid,
                                    token_secret: token_secret }

      @authentication = user.authentication
                            .create(authentication_attributes)

      authentication.persisted?
    end

    def create_team
      team_attributes = { name: slack_team["name"] }
      @team = user.team
                  .create(team_attributes)

      team.persisted?
    end

    def slack_user
      slack_identity.response["user"]
    end

    def slack_team
      slack_identity.response["team"]
    end

    def generated_password
      @generated_password ||= Devise.friendly_token.first(8)
    end
end
