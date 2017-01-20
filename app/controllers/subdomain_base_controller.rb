class SubdomainBaseController < ApplicationController
  before_action :check_team_membership, :check_confirmed_email

  helper_method :current_team
  def current_team
    subdomain_team
  end

  private

    def check_team_membership
      unless current_team && TeamPolicy.new(pundit_user, current_team).read?
        redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end

    def check_confirmed_email
      if current_user.confirmation_required? && !current_user.confirmed?
        redirect_to new_email_confirmation_path
      end
    end

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end
end
