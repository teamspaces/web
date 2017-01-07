module LoginRegisterFunnel::SignInPathForUser
  extend ActiveSupport::Concern

  def sign_in_path_for(user)
    shared_user_info = LoginRegisterFunnel::SharedUserInformation.new(session)
    sign_in_path_helper = UserSignInPathHelper.new(user, self)

    case
      when invitation_present? then sign_in_path_helper.accept_invitation_url
      when shared_user_info.user_wants_to_create_team? then sign_in_path_helper.create_team_url
      else sign_in_path_helper.url_depending_on_user_teams_count
    end
  end

  private

    def invitation_present?
      LoginRegisterFunnel::InvitationCookie.new(cookies).invitation.present?
    end
end
