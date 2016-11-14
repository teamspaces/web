class Team < ApplicationRecord
  has_many :spaces
  has_many :team_members
  has_many :users, through: :team_members
  has_many :invitations, through: :team_members
end
