class TeamAuthentication < ApplicationRecord
  belongs_to :team

  has_many :slack_profiles, class_name: "SlackProfile", primary_key: "team_uid", foreign_key: "team_id"

  validates :team, :token, presence: true
end
