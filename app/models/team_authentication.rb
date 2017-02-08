class TeamAuthentication < ApplicationRecord
  acts_as_paranoid

  belongs_to :team

  validates :team, :token, presence: true

  alias_method :disable, :destroy
  alias_method :disabled?, :paranoia_destroyed?
end
