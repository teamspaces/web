require "test_helper"

describe Space::Members::Remove, :model do
  let(:space) { spaces(:spaces) }

  subject { Space::Members::Remove }

  describe "#call" do
    it "removes user from space members" do
      result = subject.call(space: space, access_control_rule: Space::AccessControlRules::PRIVATE)

      assert result.success?
      assert_equal Space::AccessControlRules::PRIVATE, space.reload.access_control_rule
    end
  end
end
