require "test_helper"

describe Space::Members::RemoveAll, :model do
  let(:space) { spaces(:private) }

  subject { Space::Members::RemoveAll }

  describe "#call" do
    it "removes all space members" do
      assert_difference -> { space.space_members.count } do
        assert subject.call(space: space).success?
      end
    end
  end
end
