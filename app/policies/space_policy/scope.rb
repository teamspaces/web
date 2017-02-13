class SpacePolicy::Scope
  attr_reader :team, :user, :scope

  def initialize(default_context, scope)
    @team = default_context.team
    @user = default_context.user

    @scope = scope
  end

  def resolve
    scope.where(id: team_spaces + private_spaces)
  end

  private

    def team_spaces
      Space.where(team: team, access_control: Space::AccessControl::TEAM)
    end

    def private_spaces
      Space.joins(:space_members)
           .where(team: team,
                  access_control: Space::AccessControl::PRIVATE,
                  space_members: { team_member: user.team_members})
    end
end



