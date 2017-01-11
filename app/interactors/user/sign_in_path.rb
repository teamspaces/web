class User::SignInPath
  include Interactor

  def call
    @user = context.user
    @controller = context.controller
    @team_to_redirect_to = context.team_to_redirect_to

    context.path = decide_path
  end

  def decide_path
    case
      when invitation_present? then user_accept_invitation_path
      when team_creation_requested? then sign_in_path_helper.create_team_url
      when redirect_to_team? then sign_in_path_helper.team_url(@team_to_redirect_to)
      else sign_in_path_helper.url_depending_on_user_teams_count
    end
  end

  private

    def invitation_present?
      invitation_cookie.invitation.present?
    end

    def team_creation_requested?
      shared_user_info.team_creation_requested?
    end

    def redirect_to_team?
      @team_to_redirect_to.present? && team_policy_allows_user_access?(@team_to_redirect_to)
    end

    def team_policy_allows_user_access?(team)
      TeamPolicy.new(DefaultContext.new(@user, team), team).allowed_to_access?
    end

    def invitation_cookie
      @invitation_cookie ||= LoginRegisterFunnel::InvitationCookie.new(@controller.send(:cookies))
    end

    def shared_user_info
      @shared_user_info ||= LoginRegisterFunnel::SharedUserInformation.new(@controller.session)
    end

    def sign_in_path_helper
      @sign_in_path_helper ||= UserSignInPathHelper.new(@user, @controller)
    end

    def user_accept_invitation_path
      User::AcceptInvitationPath.call(user: @user, controller: @controller).path
    end
end