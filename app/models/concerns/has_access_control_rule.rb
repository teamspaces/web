module HasAccessControlRule
  extend ActiveSupport::Concern

  class AccessControlRules
    TEAM = "team"
    PRIVATE = "private"
  end

  def team?
    access_control_rule == AccessControlRules::TEAM
  end

  def private?
    access_control_rule == AccessControlRules::PRIVATE
  end
end
