
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
    @find_user = Slack::FindUser.call(slack_identity: slack_identity)
    find_user.success? ? find_user.user : nil
  end

  def create
    @create_user = Slack::CreateUser.call(slack_identity: slack_identity, token: token)
    create_user.success? ? create_user.user : nil
  end

  def rollback
    create_user.try(:rollback!)
  end
end
