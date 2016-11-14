class TeamMember < ApplicationRecord
  include HasRole

  belongs_to :team, dependent: :destroy
  belongs_to :user, dependent: :destroy

  has_many :invitations

  validates :user, uniqueness: { scope: :team }
end
