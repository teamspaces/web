require "test_helper"

describe Space::Members::Remove, :model do
  let(:user) { users(:lars) }
  let(:space) { spaces(:spaces) }

  # private space

  subject { Space::Members::Remove }

  describe "#call" do
    it "removes user from space members" do
      #sdfdf
      #result = subject.call(space: space, user: user, access_control: Space::AccessControl::PRIVATE)

      #assert result.success?
      #assert space.access_control.private?
    end
  end
end
