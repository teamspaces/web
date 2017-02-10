class TeamAuthentication < ApplicationRecord
  acts_as_paranoid

  belongs_to :team

  validates :team, :token, presence: true
end
