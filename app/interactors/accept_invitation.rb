class AcceptInvitation
  include Interactor

  attr_reader :user, :invitation

  def call
    @user = context.user
    @invitation = context.invitation

    accept_invitation
    invitation.destroy
  end

  def accept_invitation
    invitation.team.members.new(user: user, role: TeamMember::Roles::MEMBER).save
  end
end
