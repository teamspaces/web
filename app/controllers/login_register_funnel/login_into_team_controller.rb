class LoginRegisterFunnel::LoginIntoTeamController < LoginRegisterFunnel::BaseController

  before_action :authenticate_user!, only: [:login_to_subdomain_for_authenticated_user]
  skip_before_action :redirect_if_user_already_signed_in

  # point to this method, with the subdomain set to the team-subdomain where you want the user to login:
  #   example: login_into_team_url(subdomain: team_to_login.subdomain)
  # so when this method is executed, the user is already on the subdomain where he wants to login.
  # if user is already logged in on team subdomain
  #   great, user can start working on the pages
  # else if user not yet logged in on team subdomain
  #  from the available users cookie, guess which user wants to sign in
  #   if slack user => send directly to slack login
  #   if email user => prompt him to provide his password

  # Example: Call this method when user wants to directly access his team from the default-subdomain
  #          => on the default subdomain there is no current user / on the team-subdomain itself it can be figured out how to login the user

  def login_on_subdomain_uncertain_if_user_authenticated
    return redirect_to(root_subdomain_path) if already_signed_in_on_team_subdomain?

    user = user_trying_to_login_on_team_subdomain

    redirect_to case
      when user.nil? then root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      when user.login_using_slack? then team_slack_login_path_for(team: subdomain_team)
      when user.login_using_email?
        complete_login_register_funnel_review_email_address_step_for(user: user)
        new_email_login_path
    end
  end

  # point to this method, with :
  # you are already signed in on a subdomain
  #

  def login_to_subdomain_for_authenticated_user
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
