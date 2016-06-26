require 'test_helper'

class TeamMemberTest < ActiveSupport::TestCase
  let(:team_member) { team_members(:ulf_at_furrow) }

  describe "includes concerns" do
    it "HasRole" do
      assert_respond_to team_member, :member?
    end
  end
end
