
class Slack::FindOrCreateUser
  include Interactor

  attr_reader :token, :slack_identity, :find_user, :create_user

  def call
    @token = context.token
    @slack_identity = context.slack_identity

    user = find || create

    if user
      context.user = user
    else
      context.fail!
    end
  end

  def find
    @find_user = Slack::FindUser.call(uid: slack_identity_uid)
    find_user.success? ? find_user.user : nil
  end

  def create
    @create_user = Slack::CreateUser.call(slack_identity: slack_identity,
                                          uid: slack_identity_uid,
                                          token: token)

    create_user.success? ? create_user.user : nil
  end

  def rollback
    create_user.rollback
  end

  def slack_identity_uid
    "#{slack_identity.user.id}-#{slack_identity.team.id}"
  end
end
