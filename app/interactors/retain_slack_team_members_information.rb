class RetainSlackTeamMembersInformation
  include Interactor

  def call
    @team_members = context.team_members

  end
end
