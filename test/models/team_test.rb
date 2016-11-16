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

    describe "on destroy" do
      it "destroys associated spaces" do
        spaces_before = Space.count
        team.destroy
        spaces_after = Space.count

        assert spaces_before > spaces_after
      end

      it "destroys associated members" do
        members_before = TeamMember.count
        team.destroy
        members_after = TeamMember.count

        assert members_before > members_after
      end

      it "destroys associated invitations" do
        invitations_before = Invitation.count
        team.destroy
        invitations_after = Invitation.count

        assert invitations_before > invitations_after
      end
    end
  end

  it "has primary owner" do
    assert_equal team_members(:ulf_at_furrow), team.primary_owner
  end
end
