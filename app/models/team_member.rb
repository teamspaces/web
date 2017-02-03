class TeamMember < ApplicationRecord
  acts_as_paranoid

  include HasRole

  belongs_to :team
  belongs_to :user

  validates :user, uniqueness: { scope: :team }

  alias_method :disable, :destroy
  alias_method :disabled?, :paranoia_destroyed?
end
