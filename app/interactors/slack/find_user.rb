class Slack::FindUser
  include Interactor

  attr_reader :uid

  def call
    @uid = context.uid

    if existing_authentication
      context.user = existing_authentication.user
    else
      context.fail!
    end
  end

  def existing_authentication
    existing_authentication ||= Authentication.find_by(provider: :slack, uid: uid)
  end
end
