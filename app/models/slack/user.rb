class Slack::User
  #https://api.slack.com/types/user
  attr_reader :id, :team_id, :name, :deleted, :is_bot, :profile

  def initialize(opts={})
    opts.each { |k,v| instance_variable_set("@#{k}", v) }
  end

  def image
    profile["image_192"]
  end

  def full_name
    profile["real_name"]
  end

  def email
    profile["email"]
  end
end
