class User::AcceptInvitationPolicy
  attr_reader :user, :invitation

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  def matching?
    if slack_invitation?
      slack_id_matches?
    else
      email_matches?
    end
  end

  private

    def slack_id_matches?
      authentication = user.authentications.find_by(provider: :slack)

      authentication &&
      Slack::Identity::UID.parse(authentication.uid)[:user_id] == invitation.slack_id
    end

    def email_matches?
      user.email == invitation.email
    end

    def slack_invitation?
      invitation.slack_id.present?
    end
end
