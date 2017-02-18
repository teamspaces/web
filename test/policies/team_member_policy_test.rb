require "test_helper"

describe TeamMemberPolicy, :model do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:default_context) { DefaultContext.new(user, team) }

  let(:user_team_member) { team_members(:lars_at_spaces) }
  let(:normal_member) { team_members(:maja_at_spaces) }
  let(:primary_owner) { team_members(:ulf_at_spaces) }
  let(:external_team_member) { team_members(:maja_at_power) }

  describe "#destroy?" do
    it "works" do
      assert TeamMemberPolicy.new(default_context, normal_member).destroy?
    end

    context "team member does not belong to team" do
      it "returns false" do
        refute TeamMemberPolicy.new(default_context, external_team_member).destroy?
      end
    end

    context "user deletes himself from team" do
      it "returns false" do
        refute TeamMemberPolicy.new(default_context, user_team_member).destroy?
      end
    end

    context "team member to delete is primary owner" do
      it "returns false" do
        refute TeamMemberPolicy.new(default_context, primary_owner).destroy?
      end
    end
  end
end
