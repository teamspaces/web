class SubdomainBaseController < ApplicationController

  before_action :check_team_membership

  def current_team
    Team.find_by_name(request.subdomain)
  end

  private

    def check_team_membership
      unless TeamPolicy.new(pundit_user, current_team).read?
        redirect_to landing_url(subdomain: "")
      end
    end

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end
end
