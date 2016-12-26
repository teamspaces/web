module LoginRegisterFunnel::UserAcceptInvitationPath
  extend ActiveSupport::Concern

  def user_accept_invitation_path(user)
    invitation = Invitation.find_by(token: invitation_token_cookie)
    delete_invitation_token_cookie

    if invitation.present?
      policy = User::AcceptInvitationPolicy.new(user, invitation)

      if policy.matching?
        User::AcceptInvitation.call(user: user, invitation: invitation)

        flash[:notice] = t("successfully_accepted_invitation")
        team_url(subdomain: invitation.team.subdomain, auth_token: GenerateLoginToken.call(user: user))
      else
        flash[:notice] = t("invitation_does_not_match_user")
        sign_in_path_for(user)
      end
    else
      flash[:notice] = t("invitation_does_not_exist")
      sign_in_path_for(user)
    end
  end
end
