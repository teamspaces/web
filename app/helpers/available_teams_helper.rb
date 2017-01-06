module AvailableTeamsHelper
  def available_teams
    AvailableUsersCookie.new(cookies).teams
  end
end
