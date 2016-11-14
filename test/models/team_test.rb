require 'test_helper'

describe Team do
  let(:team) { teams(:furrow) }

  describe "associations" do
    it "should have many team_members" do
      assert team.members.count.positive?
    end

    it "has many invitations" do
      assert team.invitations.count.positive?
    end
  end

  it "has primary owner" do
    assert_equal team_members(:ulf_at_furrow), team.primary_owner
  end
end
