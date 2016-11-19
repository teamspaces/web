require "test_helper"

describe TeamPolicy, :model do
  let(:user) { users(:lars) }
  let(:user_team_member_team) { teams(:furrow) }
  let(:not_team_member_team) { teams(:power_rangers) }
  let(:default_context) { DefaultContext.new(user, user_team_member_team) }

  context "user is a team member" do
    it "allows all actions" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        assert TeamPolicy.new(default_context, user_team_member_team).send(action)
      end
    end
  end

  context "user is not a team member" do
    it "refutes all actions" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        refute TeamPolicy.new(default_context, not_team_member_team).send(action)
      end
    end
  end
end
