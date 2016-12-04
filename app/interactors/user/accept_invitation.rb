class User::AcceptInvitation
  include Interactor

  attr_reader :user, :invitation

  def call
    @user = context.user
    @invitation = context.invitation

    accept_team_invitation
    mark_invitation_as_accepted
  end

  def accept_team_invitation
    invitation.team.members.new(user: user, role: TeamMember::Roles::MEMBER).save
  end

  def mark_invitation_as_accepted
    invitation.invitee_user_id = user.id
    invitation.save
  end
end
