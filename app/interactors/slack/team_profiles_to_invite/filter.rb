class Slack::TeamProfilesToInvite::Filter

  def initialize(slack_team_members, team)
    @slack_team_members = slack_team_members
    @team = team
  end

  def filter
    @slack_team_members.reject(&roboter?)
                       .reject(&deleted?)
       #                .reject(&already_invited?)
       #                .reject(&already_team_member?)
  end

  private

    def roboter?
      lambda { |x| x.name == "slackbot" }
    end

    def deleted?
      lambda { |x| x.deleted == true }
    end

    def already_invited?
       invited_user_ids = @team.invitations.map(&:slack_user_id)

       lambda { |x| invited_user_ids.include? x.id }
    end

    def already_team_member?
      team_member_ids = @team.authentications.map do |authentication|
        Slack::Identity::UID.parse(authentication.uid)[:user_id]
      end

      lambda { |x| team_member_ids.include? x.id }
    end
end
