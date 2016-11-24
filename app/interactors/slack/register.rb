class Slack::Register
  include Interactor

  attr_reader :token, :slack_identity, :user

  def call
    @token = context.token
    @slack_identity = context.slack_identity

    if create_user && create_authentication
      context.user = user
    else
      context.fail!
    end
  end

  def create_user
    @user = User.new(name: slack_identity.user.name, email: slack_identity.user.email,
                     password: Devise.friendly_token.first(8))

    if user.save
      return true
    else
      Rails.logger.error("unable to create user (name=#{user.name},email=#{user.email})")
      return false
    end
  end

  def create_authentication
    @authentication = user.authentications
                          .new(provider: :slack, uid: slack_identity.uid,
                               token_secret: slack_identity.token)

    if authentication.save
      return true
    else
      Rails.logger.error("unable to create authentication (user_id=#{user.id},provider=#{authentication.provier},uid=#{authentication.uid})")
      return false
    end
  end

  def rollback

  end

  def identity_uid
    "#{slack_identity.user.id}-#{slack_identity.team.id}"
  end
end






