class SubdomainBaseController < ApplicationController
  before_action :verify_team_membership,
                :add_sentry_team_context,
                :verify_email_confirmed

  helper_method :other_available_teams
  def other_available_teams
    available_users.teams - [current_team]
  end

  helper_method :other_available_users
  def other_available_users
    available_users.users - [current_user]
  end

  helper_method :avatar_users
  def avatar_users
    sample_users_query&.users || []
  end

  helper_method :hidden_avatar_users
  def hidden_avatar_users
    sample_users_query&.users_not_in_sample_count || 0
  end

  helper_method :current_space
  def current_space
    @current_space
  end

  private

    def sample_users_query
      @sample_users_query ||=
        SampleUsersQuery.new(resource: (current_space || current_team),
                             total_users_to_sample: 4)
    end

    def verify_team_membership
      unless current_team && TeamPolicy.new(pundit_user, current_team).read?
        redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end

    def verify_email_confirmed
      unless UserPolicy.new(pundit_user, current_user).email_verified?
        User::Email::SendConfirmationInstructions.call(user: current_user, controller: self) unless current_user.confirmation_instructions_sent?

        redirect_to new_user_email_confirmation_path
      end
    end

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end

    def add_sentry_team_context
      Raven.extra_context(
          team_id: current_team.id,
          subdomain: current_team.subdomain
        )
    end
end
