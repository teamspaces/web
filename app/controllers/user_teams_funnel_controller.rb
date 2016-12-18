class UserTeamsFunnelController < ApplicationController
  include UserTeamsFunnel::CurrentUser

  skip_before_action :authenticate_user!
end
