require "test_helper"

describe Space::AccessControl::Apply, :model do
  let(:user) { users(:lars) }
  let(:space) { spaces(:spaces) }

  subject { Space::AccessControl::Apply }

  describe "#call" do
    context "private access control" do
      it "adds user to space members" do
        Space::Members::Add.expects(:call).with(space: space, user: user)

        space.access_control = Space::AccessControl::PRIVATE
        subject.call(space: space, user: user)
      end
    end

    context "team access control" do
      it "removes all space members" do
        Space::Members::RemoveAll.expects(:call).with(space: space)

        space.access_control = Space::AccessControl::TEAM
        subject.call(space: space, user: user)
      end
    end
  end
end
