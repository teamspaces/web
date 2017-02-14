require "test_helper"

describe Space::Members::Remove, :model do
  let(:user) { users(:lars) }
  let(:space) { spaces(:private) }
  let(:space_member) { space_members(:lars_at_private) }

  subject { Space::Members::Remove }

  describe "#call" do
    it "removes user from space members" do
      assert_difference -> { space.space_members.count }, -1 do
        subject.call(user: user)
      end
    end
  end
end
