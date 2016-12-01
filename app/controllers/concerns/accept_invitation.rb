module AcceptInvitation
  extend ActiveSupport::Concern

  def accept_invitation
    invitation = Invitation.find_by(token: invitation_cookie)

    if invitation.present?
      check_invitation_user_affiliation(invitation)
    else
      flash[:notice] = t(".invitation_does_not_exist")
    end

    destroy_invitation_cookie
  end

  def check_invitation_user_affiliation(invitation)
    policy = User::AcceptInvitationPolicy(current_user, invitation)

    if policy.matching?
      AcceptInvitation.call(user: user, invitation: invitation)

      flash[:notice] = t(".successfully_accepted_invitation")
    else
      flash[:notice] = t(".invitation_does_not_match_user")
    end
  end
end
