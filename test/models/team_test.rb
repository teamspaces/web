require 'test_helper'

describe Team do
  should have_many(:members).dependent(:destroy)
  should have_many(:invitations).dependent(:destroy)
  should have_many(:spaces).dependent(:destroy)
  should have_many(:pages).through(:spaces).dependent(:destroy)
  should have_many(:users).through(:members)
  should have_many(:user_authentications).through(:users).source(:authentications)
  should have_one(:team_authentication).dependent(:destroy)

  should validate_uniqueness_of(:subdomain)

  describe "#subdomain" do
    it "is set to lower case" do
      team = Team.new(subdomain: "UPPERCASE")

      assert_equal "uppercase", team.subdomain
    end
  end

  describe "#primary_owner" do
    let(:team) { teams(:spaces) }
    let(:team_primary_owner) { team_members(:ulf_at_spaces) }

    it "returns primary owner" do
      assert_equal team_primary_owner, team.primary_owner
    end
  end
end
