class SubdomainBaseController < ApplicationController

  before_filter :check_team_membership

  def check_team_membership
    unless current_team && current_user.teams.where(id: current_team.id).exists?
      redirect_to landing_url(subdomain: "")
    end
  end

  def current_team
    Team.find_by_name(request.subdomain)
  end

  private

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end
end
