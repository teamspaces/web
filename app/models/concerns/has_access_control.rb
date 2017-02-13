module HasAccessControl
  extend ActiveSupport::Concern

  class AccessControl
    TEAM = "team"
    PRIVATE = "private"
  end

  def team_access_control_rule?
    access_control_rule == AccessControl::TEAM
  end

  def private_access_control_rule?
    access_control_rule == AccessControl::PRIVATE
  end
end
