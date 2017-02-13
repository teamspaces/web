require "test_helper"

describe Space::AccessControl::Update, :model do
  let(:space) { spaces(:spaces) }

  subject { Space::AccessControl::Update }

  describe "#call" do
    it "updates space access control rule" do
      result = subject.call(space: space, access_control_rule: Space::AccessControl::PRIVATE)

      assert result.success?
      assert_equal Space::AccessControl::PRIVATE, space.reload.access_control_rule
    end
  end
end
