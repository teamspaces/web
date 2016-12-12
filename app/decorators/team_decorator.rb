class TeamDecorator < Draper::Decorator
  delegate_all

  def connected_to_slack?
    object.team_authentication
  end
end
