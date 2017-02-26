class Space::Members::Add
  include Interactor

  def call
    @space = context.space
    @user = context.user

    context.fail! unless add_space_member
  end

  private

    def add_space_member
      team_member = @user.team_members.find_by(team: @space.team)
      SpaceMember.find_or_create_by(space: @space, team_member: team_member)
    end
end
