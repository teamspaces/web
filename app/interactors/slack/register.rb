class Slack::Register
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

    authentication = user.authentications.build(provider: :slack, uid: identity_uid, token_secret: token)

    unless user.valid?
      Rails.logger.error("unable to create user #{user.attributes} with authentication #{authentication.attributes}")
    end

    user.save
  end

  def rollback
    @user.destroy
  end

  def identity_uid
    "#{slack_identity.user.id}-#{slack_identity.team.id}"
  end
end






