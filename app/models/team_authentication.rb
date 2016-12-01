class TeamAuthentication < ApplicationRecord
  belongs_to :team

  validates :team, :token, presence: true
end
