class User::AcceptInvitation
  include Interactor

  attr_reader :invited_user, :invitation

  def call
    @invited_user = context.invited_user
    @invitation = context.invitation

    context.fail! unless accept_invitation
  end

  def accept_invitation
    add_invited_user_to_team_members && save_invitation_invited_user
  end

  private

    def add_invited_user_to_team_members
      invitation.team.members.new(user: invited_user, role: TeamMember::Roles::MEMBER).save
    end

    def save_invitation_invited_user
      invitation.invited_user: invited_user
      invitation.save
    end
end
