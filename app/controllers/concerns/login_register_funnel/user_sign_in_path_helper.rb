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
end
