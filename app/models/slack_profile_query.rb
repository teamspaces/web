class SlackProfileQuery

  attr_reader :team

  def initialize(relation = SlackProfile.all)
    @relation = relation
  end


  def to_invite_for(team)
    @team = team
    not_roboter?
    not_deleted?
    not_invited?
    not_team_member?
    @relation
  end

  private

    def not_roboter?
      @relation = @relation.where.not(name: "slackbot")
    end

    def not_deleted?
     @relation =  @relation.where.not(deleted: true)
    end

    def not_invited?
      @relation = @relation.where.not(user_id:  team.invitations.map(&:slack_user_id))
    end

    def not_team_member?
      user_ids = team.authentications.map do |authentication|
        Slack::Identity::UID.parse(authentication.uid)[:user_id]
      end

     @relation =  @relation.where.not(user_id: user_ids)
    end

end
