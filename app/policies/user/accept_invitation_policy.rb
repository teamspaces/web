class User::AcceptInvitationPolicy
  attr_reader :user, :invitation

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  def matching?
    invitation.slack_invitation? ? slack_user_uid_matches? : email_matches?
  end

  private

    def slack_user_uid_matches?
      authentication = user.authentications.find_by(provider: :slack)

      authentication &&
      Slack::Identity::UID.parse(authentication.uid)[:user_id] == invitation.invited_slack_user_uid
    end

    def email_matches?
      user.email == invitation.email
    end
end
