class Space < ApplicationRecord
  acts_as_paranoid

  include SpaceCoverUploader[:cover]

  belongs_to :team
  has_many :invitations
  has_many :pages, dependent: :destroy
  has_many :space_members, dependent: :destroy
  validates :team, presence: true

  def team_members
    case
    when access_control.team? then team.members
    when access_control.private? then TeamMember.where(id: space_members.pluck(:team_member_id))
    end
  end

  def users
    User.joins(:team_members)
        .where(team_members: { id: team_members.pluck(:id) })
  end

  def access_control
    Space::AccessControl.new(self)
  end
end
