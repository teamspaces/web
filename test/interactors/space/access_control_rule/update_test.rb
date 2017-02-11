require "test_helper"


describe Space::AccessControlRule::Update, :model do
  let(:space) { spaces(:spaces) }

  subject { Space::AccessControlRule::Update }

  describe "#call" do
    it "updates space access control rule" do
      result = subject.call(space: space, access_control_rule: Space::AccessControlRules::PRIVATE)

      assert result.success?
      assert_equal Space::AccessControlRules::PRIVATE, space.reload.access_control_rule
    end
  end
end
