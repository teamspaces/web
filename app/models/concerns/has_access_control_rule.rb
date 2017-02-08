module HasAccessControlRule
  extend ActiveSupport::Concern

  class AccessControlRules
    TEAM = "team"
    PRIVATE = "private"
  end

  def team_access_control_rule?
    access_control_rule == AccessControlRules::TEAM
  end

  def private_access_control_rule?
    access_control_rule == AccessControlRules::PRIVATE
  end
end
