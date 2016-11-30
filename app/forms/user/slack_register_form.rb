class User::SlackRegisterForm
  include Inflorm

  attr_reader :authentication,
              :slack_identity,
              :generated_password,
              :user

  attribute :slack_identity, Slack::Identity
  validates :slack_identity, presence: true

  private

    def persist!
      validate_slack_identity &&
        create_user &&
        create_authentication
    end

    def validate_slack_identity
      slack_identity.success?
    end

    def slack_user
      slack.identity.slack_user
    end

    def create_user
      user_attributes = { name: slack_user["name"],
                          email: slack_user["email"],
                          password: generated_password,
                          allow_email_login: false }

      @user = User.new(user_attributes)

      if user.save
        return true
      else
        logger.error("unable to create user (name=#{user.name},email=#{user.email})")

        user.errors.full_messages.each do |message|
          errors.add(:base, :user_errors, message: message)
        end

        return false
      end
    end

    def create_authentication
      authentication_attributes = { provider: :slack,
                                    uid: slack_identity.uid,
                                    token_secret: slack_identity.token }

      @authentication = user.authentications
                            .new(authentication_attributes)

      if authentication.save
        return true
      else
        logger.error("unable to create authentication (user_id=#{user.id},provider=#{authentication.provier},uid=#{authentication.uid})")
        # TODO: "#create_authentication: unable to create from slack (user_id,uid)
        # TODO: Add user errors `errors.push(authentication.errors)`?
      end
    end

    def slack_user
      slack_identity.response["user"]
    end

    def generated_password
      @generated_password ||= Devise.friendly_token.first(8)
    end

    def logger
      Rails.logger
    end
end
