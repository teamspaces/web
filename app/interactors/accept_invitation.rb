class AcceptInvitation
  include Interactor

  attr_reader :user, :token

  def call
    @user = context.user
    @token = context.token

    if invitation.present?
      accept_invitation
      invitation.destroy
    else
      context.fail!
    end
  end

  def accept_invitation
    invitation.team.members.new(user: user, role: Roles::MEMBER).save
  end

  def invitation
    @invitation ||= Invitation.find_by(token: token)
  end
end
