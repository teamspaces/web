require "test_helper"

describe Team::CreateTeamForUser, :model do
  let(:user) { users(:lars) }

  it "creates team" do
    assert_difference -> { Team.count }, 1 do
      name = "alpa"
      result = Team::CreateTeamForUser.call(team_params: { name: name }, user: user)

      assert result.success?
      assert name, result.team.name
    end
  end

  it "creates team_member as primary owner associated to user" do
    assert_difference -> { TeamMember.count }, 1 do
      result = Team::CreateTeamForUser.call(team_params: { name: "bar" }, user: user)

      assert_equal user, result.team.members.first.user
      assert_equal TeamMember::Roles::PRIMARY_OWNER, result.team.members.first.role
    end
  end
end
