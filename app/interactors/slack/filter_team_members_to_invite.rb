class Slack::FilterTeamMembersToInvite
  include Interactor

  attr_reader :team, :slack_team_members

  def call
    @team = context.team
    @team_emails = team.users.map(&:email)
    @slack_team_members = context.slack_team_members

    filter_existent
    filter_human
    filter_not_team_member
    filter_not_already_invited

    context.members = slack_team_members
  end

  def filter_existent
    @slack_team_members.reject! { |user| user.deleted }
  end

  def filter_human
    @slack_team_members.reject! { |user| user.is_bot || user.name == "slackbot"}
  end

  def filter_not_team_member
    @slack_team_members.reject! { |user| @team_emails.include? user.email }
  end

  def filter_not_already_invited
    #email und username ist nicht drin // wobei is eig scheiß egal
    #sobald eingeladen wird nach
  end
end
