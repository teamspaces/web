require "test_helper"

describe Space do
  let(:team) { teams(:spaces) }
  let(:team_space) { spaces(:spaces) }
  let(:private_space) { spaces(:private) }

  should have_many(:invitations)
  should have_many(:pages).dependent(:destroy)
  should have_many(:space_members).dependent(:destroy)
  should belong_to(:team)
  should validate_presence_of(:team)

  describe "#team_members" do
    context "private" do
      it "returns only space_members" do
        assert_equal [team_members(:lars_at_spaces)], private_space.team_members
      end
    end

    context "team" do
      it "returns all team team_members" do
        assert_equal team.members.order(:id).pluck(:id), team_space.team_members.order(:id).pluck(:id)
      end
    end
  end

  describe "#users" do
    context "private" do
      it "returns only space users" do
        assert_equal [users(:lars)], private_space.users
      end
    end

    context "team" do
      it "returns all team users" do
         assert_equal team.users.order(:id).pluck(:id), team_space.users.order(:id).pluck(:id)
      end
    end
  end

  describe "#users" do
    it "returns space users" do
      assert true
    end
  end
end
