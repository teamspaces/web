require 'test_helper'

describe TeamMember do
  let(:team_member) { team_members(:ulf_at_furrow) }

  describe "validations" do
    it "is unique user per team" do
      duplicated_team_member = TeamMember.new(user: team_member.user,
                                              team: team_member.team)
       duplicated_team_member.valid?
       team_member_errors = duplicated_team_member.errors.messages[:user]
       assert_includes team_member_errors, "has already been taken"
    end
  end

  describe "includes concerns" do
    it "HasRole" do
      assert_respond_to team_member, :member?
    end
  end
end
