class User::AcceptInvitation
  include Interactor

  attr_reader :invited_user, :invitation

  def call
    @invited_user = context.invited_user
    @invitation = context.invitation

    context.fail! unless accept_team_invitation &&
                         accept_space_invitation &&
                         confirm_email
  end

  def accept_team_invitation
    add_invited_user_to_team_members && save_invitation_invited_user
  end

  def accept_space_invitation
    @invitation.space.present? ? Space::Members::Add.call(space: @invitation.space,
                                                          user: @invited_user) : true
  end

  def confirm_email
    invited_user.confirm if invitation.email_invitation?
    true
  end

  private

    def add_invited_user_to_team_members
      invitation.team.members.new(user: invited_user, role: TeamMember::Roles::MEMBER).save
    end

    def save_invitation_invited_user
      invitation.invited_user = invited_user
      invitation.save
    end
end
