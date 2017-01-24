class SubdomainBaseController < ApplicationController
  before_action :verify_team_membership, :verify_email_confirmed

  helper_method :current_team
  def current_team
    subdomain_team
  end

  private

    def verify_team_membership
      unless current_team && TeamPolicy.new(pundit_user, current_team).read?
        redirect_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end

    def verify_email_confirmed
      unless UserPolicy.new(pundit_user, current_user).email_verified?
        redirect_to new_user_email_confirmation_path
      end
    end

    def pundit_user
      DefaultContext.new(current_user, current_team)
    end
end
