class Space::AccessControl::Add
  include Interactor

  def call
    @space = context.space
    @initiating_user = context.initiating_user

    context.fail! unless add_access_control && add_space_member
  end

  private

    def add_access_control
      @space.update(access_control: true)
    end

    def add_space_member
      team_member = @initiating_user.team_members.find_by(team: @space.team)
      SpaceMember.find_or_create_by(space: @space, team_member: team_member)
    end
end
