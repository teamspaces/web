require "test_helper"

describe CreateTeamForUser, :model do
  subject { CreateTeamForUser }
  let(:user) { users(:lars) }
  let(:pirmary_role) { TeamMember::Roles::PRIMARY_OWNER }

  it "creates team" do
    assert_difference -> { Team.count }, 1 do
      name = "alpa"
      result = subject.call(team_params: { name: name }, user: user)

      assert result.success?
      assert name, result.team.name
    end
  end

  it "creates team_member as primary owner associated to user" do
    assert_difference -> { TeamMember.count }, 1 do
      result = subject.call(team_params: { name: "bar" }, user: user)

      assert_equal user, result.team.members.first.user
      assert_equal pirmary_role, result.team.members.first.role
    end
  end
end
