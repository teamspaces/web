require 'test_helper'

describe TeamMember do
  let(:team_member) { team_members(:ulf_at_furrow) }

  should belong_to(:team)
  should belong_to(:user)

  should validate_uniqueness_of(:user).scoped_to(:team_id)

  describe "includes concerns" do
    it "HasRole" do
      assert_respond_to team_member, :member?
    end
  end
end
