require "test_helper"

describe CreateTeamMemberForNewTeam, :model do
  let(:user) { users(:without_team) }
  let(:team) { teams(:furrow) }
  let(:primary_role) { TeamMember::Roles::PRIMARY_OWNER }

  it "creates team_member as primary owner associated to user" do
    assert_difference -> { TeamMember.count }, 1 do
      result = CreateTeamMemberForNewTeam.call(team: team, user: user)

      assert result.success?
      assert_equal user, result.team_member.user
      assert_equal primary_role, result.team_member.role
    end
  end
end
