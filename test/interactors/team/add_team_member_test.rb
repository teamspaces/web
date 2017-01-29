require "test_helper"

describe Team::AddTeamMember, :model do
  let(:user) { users(:without_team) }
  let(:team) { teams(:spaces) }
  let(:primary_role) { TeamMember::Roles::PRIMARY_OWNER }

  it "creates a team_member" do
    assert_difference -> { TeamMember.count }, 1 do
      result = CreateTeamMemberForNewTeam.call(team: team,
                                               user: user,
                                               role: primary_role)

      assert result.success?
      assert_equal user, result.team_member.user
      assert_equal primary_role, result.team_member.role
    end
  end
end
