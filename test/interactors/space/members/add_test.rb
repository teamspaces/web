require "test_helper"

describe Space::Members::Add, :model do
  let(:user) { users(:lars) }
  let(:space) { spaces(:spaces) }

  subject { Space::Members::Add }

  describe "#call" do
    it "adds space member" do
      assert_difference -> { space.space_members.count }, 1 do
        result = subject.call(space: space, user: user)
        assert result.success?
      end
    end

    describe "space member already exists" do
      it "does nothing" do
        subject.call(space: space, user: user)

        assert_difference -> { space.space_members.count }, 0 do
          result = subject.call(space: space, user: user)
          assert result.success?
        end
      end
    end
  end
end
