module InvitationTokenSignUpIn
  extend ActiveSupport::Concern

  #ovverrides devise session create and devise registration create
  def create
    if upon_invitation? && !invitation_matches_email?(params[:user][:email])
      redirect_and_show_email_invitation_inconsistency
    else
      super do |user|
        oben extra service draus machen
        user.persisted?
        #user.update_attributes(foo: :bar)
      end
    end
  end

  def upon_invitation?
    params[:invitation_token].present? && invitation_from_token_param
  end

  def invitation_matches_email?(email)
    email == invitation_from_token_param.email
  end

  def redirect_and_show_email_invitation_inconsistency
    flash[:notice] = t(:invitation_does_not_match_provided_email)
    redirect_back(fallback_location: landing_path)
  end

  def invitation_from_token_param
    Invitation.find_by(token: params[:invitation_token])
  end
end
