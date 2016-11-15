require "test_helper"

describe Team::CreateTeamForUser, :model do
  let(:user) { users(:lars) }

  it "creates team" do
    assert_difference -> { Team.count }, 1 do
      name = "alpa"
      success, team = Team::CreateTeamForUser.call({ name: name }, user)

      assert success
      assert name, team.name
    end
  end

  it "creates team_member as primary owner associated to user" do
    assert_difference -> { TeamMember.count }, 1 do
      success, team = Team::CreateTeamForUser.call({ name: "bar" }, user)

      assert_equal user, team.members.first.user
      assert_equal TeamMember::Roles::PRIMARY_OWNER, team.members.first.role
    end
  end
end
