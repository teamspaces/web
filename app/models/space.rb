class Space < ApplicationRecord
  include SpaceCoverUploader[:cover]

  has_many :pages, dependent: :destroy
  has_many :space_members, dependent: :destroy
  belongs_to :team
  validates :team, presence: true

  def users
    if access_control
      User.joins(:team_members)
          .where(team_members: {
                  id: space_members.pluck(:team_member_id)
            }).distinct
    else
      team.users
    end
  end
end
