class Space < ApplicationRecord
  include HasAccessControlRule
  include SpaceCoverUploader[:cover]

  belongs_to :team
  has_many :invitations
  has_many :pages, dependent: :destroy
  has_many :space_members, dependent: :destroy
  validates :team, presence: true

  def team_members
    case
    when team_access_control_rule? then team.members
    when private_access_control_rule? then TeamMember.where(id: space_members.pluck(:team_member_id))
    end
  end

  def users
    User.joins(:team_members)
        .where(team_members: { id: team_members.pluck(:id) })
  end
end
