class Team < ApplicationRecord
  has_many :projects
  has_and_belongs_to_many :users, through: :team_members
end
