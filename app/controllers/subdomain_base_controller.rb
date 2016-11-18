class SubdomainBaseController < ApplicationController

  before_action :check_team_membership

  def current_team
    Team.find_by_name(request.subdomain)
  end

  private

    def check_team_membership
      unless current_team && current_user.teams.where(id: current_team.id).exists?
        redirect_to landing_url(subdomain: "")
      end
    end

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end
end
