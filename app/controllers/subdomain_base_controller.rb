class SubdomainBaseController < ApplicationController
  before_action :check_team_membership

  helper_method :current_team
  def current_team
    subdomain_team
  end

  private

    def check_team_membership
      unless current_team && TeamPolicy.new(pundit_user, current_team).read?
        user = user_trying_to_login_on_team_subdomain

        redirect_to case
          when user.nil? then root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
          when user.login_using_slack? then team_slack_login_path_for(team: subdomain_team)
          when user.login_using_email?
            complete_login_register_funnel_review_email_address_step_for(user: user)
            new_email_login_path
        end
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

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end
end
