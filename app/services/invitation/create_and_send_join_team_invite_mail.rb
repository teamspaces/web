class Invitation::CreateAndSendJoinTeamInviteMail

  def self.call(invitation_params, team, user)
    invitation = team.invitations.new(invitation_params)
    invitation.user = user

    if invitation.save
      InvitationMailer.join_team(invitation).deliver_later

      [true , invitation]
    else
      [false, invitation]
    end
  end
end
