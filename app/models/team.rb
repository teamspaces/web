class Team < ApplicationRecord
  has_many :spaces, dependent: :destroy
  has_many :pages, through: :spaces, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :members, foreign_key: "team_id", class_name: "TeamMember", dependent: :destroy
  has_many :users, through: :members
  has_many :user_authentications, through: :users, source: :authentications
  has_many :team_authentications

  def primary_owner
    self.members.find_by(role: TeamMember::Roles::PRIMARY_OWNER)
  end
end
