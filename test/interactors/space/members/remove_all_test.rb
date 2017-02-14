require "test_helper"

describe Space::Members::RemoveAll, :model do
  let(:space) { spaces(:private) }

  subject { Space::Members::RemoveAll }

  describe "#call" do
    it "removes all space members" do
      result = subject.call(space: space)

      assert result.success?
      assert_equal 0, space.space_members.count
    end
  end
end
