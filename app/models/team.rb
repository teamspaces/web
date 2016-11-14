class Team < ApplicationRecord
  has_many :spaces
  has_many :members, foreign_key: "team_id", class_name: "TeamMember"
  has_many :users, through: :members
end
