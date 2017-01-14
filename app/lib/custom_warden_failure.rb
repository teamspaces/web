class CustomWardenFailure < Devise::FailureApp
  def redirect_url
    if on_team_subdomain?
      user = user_trying_to_login_on_team_subdomain

      redirect_to case
        when user.nil? then root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
        when user.login_using_slack? then team_slack_login_path_for(team: subdomain_team)
        when user.login_using_email?
          complete_login_register_funnel_review_email_address_step_for(user: user)
          new_email_login_path
        end
    else
      redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
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

  def on_team_subdomain?
    subdomain_team.present?
  end

  def subdomain_team
    @subdomain_team ||= Team.find_by(subdomain: request.subdomain)
  end

  def available_users
    @available_users ||= LoginRegisterFunnel::BaseController::AvailableUsersCookie.new(request.cookies)
  end
end
