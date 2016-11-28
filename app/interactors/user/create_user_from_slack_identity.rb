class User::CreateUserFromSlackIdentity
  include Interactor

  attr_reader :token, :slack_identity, :user

  def call
    @token = context.token
    @slack_identity = context.slack_identity

    if create_user_with_authentication
      context.user = user
    else
      context.fail!
    end
  end

  def create_user_with_authentication
    @user = User.new(name: slack_identity.user.name, email: slack_identity.user.email,
                     password: Devise.friendly_token.first(8))

    authentication = user.authentications.build(provider: :slack, uid: Slack::Identity::UID.build(slack_identity), token_secret: token)

    unless user.valid?
      Rails.logger.error("User::CreateUserFromSlackIdentity#create_user_with_authentication failed to create user (user.email=#{user.email}, user.first_name=#{user.first_name}, user.last_name=#{user.last_name}) with authentication: (authentication.uid=#{authentication.uid}) erros: (#{user.errors.full_messages})")
    end

    user.save
  end

  def rollback
    user.destroy
  end
end
