class Slack::LoginOrRegister
  include Interactor

  attr_reader :token, :slack_identity, :slack_login, :slack_register

  def call
    @token = context.token
    @slack_identity = context.slack_identity

    user = login || register

    if user
      context.user = user
    else
      context.fail!
    end
  end

  def rollback
    @slack_register.rollback
  end

  def login
    @slack_login = Slack::Login.call(slack_identity: slack_identity)
    slack_login.success? ? slack_login.user : nil
  end

  def register
    @slack_register = Slack::Register.call(slack_identity: slack_identity, token: token)
    slack_register.success? ? slack_register.user : nil
  end
end
