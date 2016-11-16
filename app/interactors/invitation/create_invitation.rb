class Invitation::CreateInvitation
  include Interactor

  def call
    context.invitation_form = Invitation::InvitationForm.new(context.invitation_params)
    context.invitation_form.team = context.team
    context.invitation_form.user = context.user

    if context.invitation_form.save
      context.invitation = context.invitation_form.invitation
    else
      context.fail!
    end
  end
end
