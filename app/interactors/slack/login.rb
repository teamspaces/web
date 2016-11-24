class Slack::Login
  include Interactor

  attr_reader :slack_identity

  def call
    @slack_identity = context.slack_identity

    if existing_identity
      context.user = existing_identity.user
    else
      context.fail!
    end
  end

  def existing_identity
    existing_identity ||= Authentication.find_by(provider: :slack, uid: identity_uid)
  end

  def identity_uid
    "#{slack_identity.user.id}-#{slack_identity.team.id}"
  end
end
