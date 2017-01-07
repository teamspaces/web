class UserSignInPathHelper

  def initialize(user, controller)
    @user = user
    @controller = controller
  end

  def create_team_url
    @controller.login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: @user))
  end

  def url_depending_on_user_teams_count
    case @user.teams.count
      when 0
        @controller.login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: @user))
      when 1
        @controller.team_url(subdomain: @user.teams.first.subdomain, auth_token: GenerateLoginToken.call(user: @user))
      else
        @controller.login_register_funnel_list_teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: @user))
      end
  end

  def accept_invitation_url
    invitation = invitation_cookie.invitation
    invitation_cookie.delete

    if invitation.present?
      policy = User::AcceptInvitationPolicy.new(@user, invitation)

      if policy.matching?
        User::AcceptInvitation.call(user: @user, invitation: invitation)

        flash[:notice] = t("successfully_accepted_invitation")
        @controller.team_url(subdomain: invitation.team.subdomain, auth_token: GenerateLoginToken.call(user: @user))
      else
        flash[:notice] = t("invitation_does_not_match_user")
        @controller.sign_in_path_for(user)
      end
    else
      flash[:notice] = t("invitation_does_not_exist")
      @controller.sign_in_path_for(user)
    end
  end

  private

    def invitation_cookie
      @invitation_cookie ||= LoginRegisterFunnel::InvitationCookie.new(cookies)
    end
end
