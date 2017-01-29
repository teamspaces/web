require 'test_helper'

describe AvailableUsersQuery, :controller do
  let(:default_user) { users(:ulf) }
  let(:user_with_several_teams){ users(:with_several_teams) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:available_users) { AvailableUsersQuery.new(controller.send(:cookies)) }

  describe "#users" do
    it "returns all users with an active session" do
      controller.sign_in(default_user)

      assert_includes available_users.users, default_user
      assert_not_includes available_users.users, user_with_several_teams
    end
  end

  describe "#teams" do
    it "returns all teams of all users with an active session" do
      controller.sign_in(user_with_several_teams)

      user_with_several_teams.teams.each do |team|
        assert_includes available_users.teams, team
      end
    end
  end

  describe "#available_user_member_of_team" do
    let(:user_with_several_teams_team) { teams(:power_rangers) }

    it "returns the available user who is member of the team" do
      controller.sign_in(default_user)
      controller.sign_in(user_with_several_teams)

      assert_equal user_with_several_teams, available_users.available_user_member_of_team(user_with_several_teams_team)
    end
  end
end
