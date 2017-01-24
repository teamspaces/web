require "test_helper"

describe UserTeamsQuery, :model do
  let(:primary_owner_user_of_spaces) { users(:ulf) }
  let(:member_user_of_spaces) { users(:slack_user_milad) }
  let(:spaces_team) { teams(:spaces) }
  let(:user_without_team) { users(:without_team) }
  subject { UserTeamsQuery }

  describe "#recently_created_team" do
    it "returns team created as primary owner in the last 5 hours" do
      assert_equal subject.new(primary_owner_user_of_spaces).recently_created_team, spaces_team
    end

    context "user has not teams" do
      it "returns nil" do
        assert_nil subject.new(user_without_team).recently_created_team
      end
    end

    context "user is not primary owner" do
      it "returns nil" do
        assert_nil subject.new(member_user_of_spaces).recently_created_team
      end
    end

    context "team was not recently created" do
      it "returns nil" do
        spaces_team.update(created_at: Date.yesterday)

        assert_nil subject.new(primary_owner_user_of_spaces).recently_created_team
      end
    end
  end
end
