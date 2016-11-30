class Slack::Identity::UID

  def self.build(slack_identity)
    "#{slack_identity.user.id}-#{slack_identity.team.id}"
  end

  def self.parse(uid)
    splitted = uid.split("-")

    {user_id: splitted[0], team_id: splitted[1] }
  end
end
