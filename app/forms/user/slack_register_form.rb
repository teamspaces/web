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
        
        # TODO: Add an error "We're unable to connect with Slack right now."

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
        # TODO: "#create_user: unable to create from slack (name,email,user.errors)
        # TODO: Add user errors `errors.push(user.errors)`?
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
