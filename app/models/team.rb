class Team < ApplicationRecord
  include TeamLogoUploader[:logo]

  has_many :spaces, dependent: :destroy
  has_many :pages, through: :spaces, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :members, foreign_key: "team_id", class_name: "TeamMember", dependent: :destroy
  has_many :users, through: :members
  has_many :user_authentications, source: :authentications, through: :users
  has_one :team_authentication, dependent: :destroy

  validates_uniqueness_of :subdomain

  def subdomain=(val)
    write_attribute(:subdomain, val&.downcase)
  end

  def primary_owner
    self.members.find_by(role: TeamMember::Roles::PRIMARY_OWNER)
  end
end
