module LoginRegisterFunnel::SignInPathForUser
  include LoginRegisterFunnel::UserAcceptInvitationPath
  extend ActiveSupport::Concern

  def sign_in_path_for(user, team_to_redirect_to=nil)
    AvailableUsersCookie.new(cookies).add(user)

    shared_user_info = LoginRegisterFunnel::SharedUserInformation.new(session)
    sign_in_path_helper = UserSignInPathHelper.new(user, self)

    case
      when invitation_present? then user_accept_invitation_path(user)
      when shared_user_info.team_creation_requested? then sign_in_path_helper.create_team_url
      when team_to_redirect_to.present? && team_policy(user, team_to_redirect_to).allowed_to_access?
        then sign_in_path_helper.team_url(team_to_redirect_to)
      else sign_in_path_helper.url_depending_on_user_teams_count
    end
  end

  private

    def invitation_present?
      invitation_cookie.invitation.present?
    end

    def invitation_cookie
      @invitation_cookie ||= LoginRegisterFunnel::InvitationCookie.new(cookies)
    end

    def team_policy(user, team)
      TeamPolicy.new(DefaultContext.new(user, team), team)
    end
end
