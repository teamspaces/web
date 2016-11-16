class Invitation::CreateInvitation
  include Interactor

  def call
    context.invitation = context.team.invitations.new(context.invitation_params)
    context.invitation.user = context.user

    context.fail! unless context.invitation.save
  end
end
