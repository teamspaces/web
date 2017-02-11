require "test_helper"

describe Space::AccessControlRule::Enforce, :model do
  let(:user) { users(:lars) }
  let(:space) { spaces(:spaces) }

  subject { Space::AccessControlRule::Enforce }

  describe "#call" do
    describe "it enforces access control rule" do
      context "private access control rule" do
        it "adds user to space members" do
          Space::Members::Add.expects(:call).with(space: space, user: user)

          space.access_control_rule = Space::AccessControlRules::PRIVATE
          subject.call(space: space, user: user)
        end
      end

      context "team access control rule" do
        it "removes all space members" do
          Space::Members::RemoveAll.expects(:call).with(space: space)

          space.access_control_rule = Space::AccessControlRules::TEAM
          subject.call(space: space, user: user)
        end
      end
    end
  end
end
