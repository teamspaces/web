class SpaceMember < ApplicationRecord
  belongs_to :space
  belongs_to :team_member

  validates :team_member, uniqueness: { scope: :space }
end
