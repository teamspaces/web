class User::AcceptInvitation
  include Interactor

  attr_reader :user, :invitation

  def call
    @user = context.user
    @invitation = context.invitation.decorate

    accept_team_invitation
    mark_invitation_as_accepted
    confirm_email
  end

  def accept_team_invitation
    invitation.team.members.new(user: user, role: TeamMember::Roles::MEMBER).save
  end

  def mark_invitation_as_accepted
    invitation.invitee_user_id = user.id
    invitation.save
  end

  def confirm_email
    @user.confirm if @invitation.email_invitation?
  end
end
