class SlackProfile < ApplicationRecord
  scope :belonging_to, ->(team) { where(team_id: team.team_authentication.team_uid) }
end
