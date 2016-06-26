class TeamMember < ApplicationRecord
  include HasRole
  
  belongs_to :team
  belongs_to :user
end
