class AcceptInvitation
  include Interactor

  attr_reader :user, :token

  def call
    @user = context.user
    @token = context.token

    if invitation.present? && invitation_belongs_to_user?
      accept_invitation
      invitation.destroy
    else
      context.fail!
    end
  end

  def accept_invitation
    invitation.team.members.new(user: user, role: TeamMember::Roles::MEMBER).save
  end

  def invitation_belongs_to_user?
    invitation.email == user.email
  end

  def invitation
    @invitation ||= Invitation.find_by(token: token)
  end
end
