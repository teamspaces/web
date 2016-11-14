class TeamMember < ApplicationRecord
  include HasRole

  belongs_to :team, dependent: :destroy
  belongs_to :user, dependent: :destroy

  validates :user, uniqueness: { scope: :team }
end
