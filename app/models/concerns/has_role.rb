module HasRole
  extend ActiveSupport::Concern

  class Roles
    PRIMARY_OWNER = "primary_owner"
    OWNER         = "owner"
    MEMBER        = "member"
  end

  def primary_owner?
    role == Roles::PRIMARY_OWNER
  end

  def owner?
    role == Roles::OWNER
  end

  def member?
    role == Roles::MEMBER
  end
end
