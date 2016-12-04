require 'test_helper'

describe Team do
  should have_many(:members).dependent(:destroy)
  should have_many(:invitations).dependent(:destroy)
  should have_many(:spaces).dependent(:destroy)
  should have_many(:pages).through(:spaces).dependent(:destroy)
  should have_many(:users).through(:members)
  should have_one(:team_authentication).dependent(:destroy)

  describe "#primary_owner" do
    let(:team) { teams(:furrow) }
    let(:team_primary_owner) { team_members(:ulf_at_furrow) }

    it "returns primary owner" do
      assert_equal team_primary_owner, team.primary_owner
    end
  end
end
