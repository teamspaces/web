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
        create_authentication
    end

    def find_user_on_slack
      begin
        @slack_identity = Slack::Identity.new(token_secret)
        slack_identity.fetch
      rescue Faraday::Error => e
        logger.error("User::SlackRegisterForm#find_user_on_slack: #{e.message}")
        logger.error e.backtrace.join("\n")

        errors.add(:base, :unable_to_connect_with_slack,
          message: "Slack is currently unreachable.")

        return false
      end

      slack_identity.success?
    end

    def create_user
      user_attributes = { name: slack_user["name"],
                          email: slack_user["email"],
                          password: generated_password }

      @user = User.new(user_attributes)

      if user.save
        return true
      else
        logger.error("User::SlackRegisterForm#create_user: unable to create from slack (name=#{user.name},email=#{user.email})")
        
        user.errors.full_messages.each do |message|
          errors.add(:base, :user_errors, message: message)
        end

        return false
      end
    end

    def create_authentication
      authentication_attributes = { provider: :slack,
                                    uid: slack_identity.uid,
                                    token_secret: token_secret }

      @authentication = user.authentication
                            .new(authentication_attributes)

      if authentication.save
        return true
      else
        # TODO: "#create_authentication: unable to create from slack (user_id,uid)
        # TODO: Add user errors `errors.push(authentication.errors)`?
      end
    end

    def slack_user
      slack_identity.response["user"]
    end

    # slack_team["name"]
    # def slack_team
    #   slack_identity.response["team"]
    # end

    def generated_password
      @generated_password ||= Devise.friendly_token.first(8)
    end
end
