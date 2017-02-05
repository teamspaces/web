class Space < ApplicationRecord
  include SpaceCoverUploader[:cover]

  has_many :pages, dependent: :destroy
  has_many :space_members, dependent: :destroy
  belongs_to :team
  validates :team, presence: true

  def team_members
    if access_control
      TeamMember.where(id: space_members.pluck(:team_member_id))
    else
      team.team_members
    end
  end

  def users
    User.joins(:team_members)
        .where(team_members: { id: team_members })
  end
end
