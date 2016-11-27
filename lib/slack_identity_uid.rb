class SlackIdentityUid

  def self.build(slack_identity)
    "#{slack_identity.user.id}-#{slack_identity.team.id}"
  end

end
