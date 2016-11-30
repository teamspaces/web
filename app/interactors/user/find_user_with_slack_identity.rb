class User::FindUserWithSlackIdentity
  include Interactor

  attr_reader :slack_identity

  def call
    @slack_identity = context.slack_identity

    if existing_authentication
      context.user = existing_authentication.user
    else
      context.fail!
    end
  end

  def existing_authentication
    existing_authentication = begin
      Authentication.find_by(provider: :slack,
                             uid: uid)
    end
  end

  private

    def uid
      Slack::Identity::UID.build(slack_identity)
    end
end
