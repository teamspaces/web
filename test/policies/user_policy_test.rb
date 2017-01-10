require "test_helper"

describe UserPolicy, :model do
  let(:current_user) { users(:lars) }
  let(:not_current_user) { users(:ulf) }
  let(:current_team) { current_user.teams.first }
  let(:default_context) { DefaultContext.new(current_user, current_team) }

  context "user is current_user" do
    it "allows all actions" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        assert TeamPolicy.new(default_context, current_user).send(action)
      end
    end
  end

  context "user is not current_user" do
    it "refutes all actions" do
      [:show?, :new?, :edit?, :create?, :update?, :destroy?].each do |action|
        refute TeamPolicy.new(default_context, not_current_user).send(action)
      end
    end
  end
end
