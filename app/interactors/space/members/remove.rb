class Space::Members::Remove
  include Interactor

  def call
    @space = context.space
    @user = context.user

    context.fail! unless remove_space_member
  end

  private

    def remove_space_member
      team_member = @user.team_members.find_by(team: @space.team)
      SpaceMember.find_by(space: @space, team_member: team_member).destroy
    end
end
