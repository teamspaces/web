class SubdomainBaseController < ApplicationController
  before_action :check_team_membership
  before_action :redirect_unfocomfirmed_users

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

    def redirect_unfocomfirmed_users
      redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]) if (confirmation_required? && !current_user.confirmed?) # pending_reconfirmation? wenn email geupdated
    end

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end
end
