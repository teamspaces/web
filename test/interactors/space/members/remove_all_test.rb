require "test_helper"

describe Space::Members::RemoveAll, :model do
  let(:space) { spaces(:private) }

  subject { Space::Members::RemoveAll }

  describe "#call" do
    it "removes all space members" do
      assert subject.call(space: space).success?
      assert_equal 0, space.reload.space_members.count
    end
  end
end
