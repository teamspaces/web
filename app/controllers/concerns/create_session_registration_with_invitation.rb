module CreateSessionRegistrationWithInvitation
  extend ActiveSupport::Concern

  #overrides devise sessions_controller.rb create
  #overrider devise registrations_controller.rb create
  def create
    if upon_invitation? && !invitation_matches_email?(params[:user][:email])
      redirect_back_and_show_invitation_email_inconsistency
    else
      super do |user|
        if upon_invitation? && user.persisted?
          AcceptInvitation.call(user: user, token: invitation_from_token_param)
        end
      end
    end
  end

  private
    def upon_invitation?
      params[:invitation_token].present? && invitation_from_token_param
    end

    def invitation_matches_email?(email)
      email == invitation_from_token_param.email
    end

    def redirect_back_and_show_invitation_email_inconsistency
      flash[:notice] = t(:invitation_does_not_match_provided_email)
      redirect_back(fallback_location: landing_path)
    end

    def invitation_from_token_param
      Invitation.find_by(token: params[:invitation_token])
    end
end
