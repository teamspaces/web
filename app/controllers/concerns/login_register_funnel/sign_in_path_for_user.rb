module LoginRegisterFunnel::SignInPathForUser
  include LoginRegisterFunnel::UserAcceptInvitationPath
  extend ActiveSupport::Concern

  def sign_in_path_for(user)
    shared_user_info = LoginRegisterFunnel::SharedUserInformation.new(session)
    sign_in_path_helper = UserSignInPathHelper.new(user, self)

    case
      when invitation_present? then user_accept_invitation_path(user)
      when shared_user_info.user_wants_to_create_team? then sign_in_path_helper.create_team_url
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
end
