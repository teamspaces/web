class Slack::Identity::UID

  def self.build(slack_identity)
    "#{slack_identity.user.id}-#{slack_identity.user.team_id}"
  end

  def self.parse(uid)
    user_id, team_id = uid.split("-")
    { user_id: user_id, team_id: team_id }
  end
end
