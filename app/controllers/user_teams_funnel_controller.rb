class UserTeamsFunnelController < ApplicationController
  include UserTeamsFunnel::CurrentUser

  before_action :set_user
  skip_before_action :authenticate_user!

  private
    def set_user
      user_teams_funnel_current_user
    end
end
