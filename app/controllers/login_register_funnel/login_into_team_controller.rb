class LoginRegisterFunnel::LoginIntoTeamController < LoginRegisterFunnel::BaseController

  before_action :authenticate_user!, only: [:on_another_user_subdomain]
  skip_before_action :redirect_if_user_already_signed_in

  def already_on_subdomain
    return redirect_to(root_subdomain_path) if already_signed_in_on_team_subdomain?

    user = user_trying_to_login_on_team_subdomain

    redirect_to case
      when user.login_using_slack? then team_slack_login_path_for(team: subdomain_team)
      when user.login_using_email?
        complete_login_register_funnel_review_email_address_step_for(user: user)
        new_email_login_path
    end
  end

  def on_another_user_subdomain
    #if team_to_redirect_to belongs to user
    #then sign in with jwt token
    #else redirect to subdomain and figure out a way to sign in
    #end
    if current_user.teams.exists?(team_to_redirect_to)
      sign_in_url_for_user = LoginRegisterFunnel::BaseController::SignInUrlForUser.new(current_user, self)

      redirect_to sign_in_url_for_user.team_spaces_url(team_to_redirect_to)
    else
      redirect_to login_into_team_url(subdomain: team_to_redirect_to.subdomain)
    end
  end

  private

    def already_signed_in_on_team_subdomain?
      user_signed_in?
    end

    def user_trying_to_login_on_team_subdomain
      subdomain_team.users.find_by(id: available_users.users)&.decorate
    end

    def team_slack_login_path_for(team:)
      user_slack_omniauth_authorize_url(subdomain: ENV["DEFAULT_SUBDOMAIN"], state: :login, team_id: team.id)
    end

    def complete_login_register_funnel_review_email_address_step_for(user:)
      shared_user_info.reviewed_email_address = user.email
    end

    def team_to_redirect_to
      @team_to_redirect_to ||= params[:team_to_redirect_to_subdomain].present? ? Team.find_by(subdomain: params[:team_to_redirect_to_subdomain]) : nil
    end
end
