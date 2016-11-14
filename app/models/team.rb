class Team < ApplicationRecord
  has_many :spaces
  has_many :members, foreign_key: "team_id", class_name: "TeamMember"
  has_many :users, through: :members
  has_many :invitations, through: :members

  def primary_owner
    self.members.find_by(role: TeamMember::Roles::PRIMARY_OWNER)
  end
end
