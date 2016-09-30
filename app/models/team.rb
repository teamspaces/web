class Team < ApplicationRecord
  has_many :spaces
  has_and_belongs_to_many :users, through: :team_members
end
