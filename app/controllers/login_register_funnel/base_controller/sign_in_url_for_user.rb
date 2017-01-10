class LoginRegisterFunnel::BaseController::SignInUrlForUser

  def initialize(user, controller)
    @user = user
    @controller = controller
  end

  def create_team_url
    @controller.login_register_funnel_new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: @user))
  end

  def team_url(team)
    @controller.team_url(subdomain: team.subdomain, auth_token: GenerateLoginToken.call(user: @user))
  end

  def choose_team_url
    @controller.login_register_funnel_list_teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], auth_token: GenerateLoginToken.call(user: @user))
  end

  def url_depending_on_user_teams_count
    case @user.teams.count
      when 0 then create_team_url
      when 1 then team_url(@user.teams.first)
      else choose_team_url
    end
  end
end
