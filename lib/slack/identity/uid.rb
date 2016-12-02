class Slack::Identity::UID

  def self.build(slack_identity)
    "#{slack_identity.user.id}-#{slack_identity.user.team_id}"
  end
end
