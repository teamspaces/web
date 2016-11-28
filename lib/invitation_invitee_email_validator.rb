class InvitationInviteeEmailValidator < ActiveModel::Validator
  def validate(form)
    if form.invitation && form.user
      if form.invitation.email != form.user.email
        form.errors.add(:email, :does_not_match_invited_email)
      end
    end
  end
end
