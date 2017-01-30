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

  describe "#user_signed_in_on_another_subdomain" do
    let(:user_with_several_teams_team) { teams(:power_rangers) }

    context "team user is signed in on another team subdomain" do
      it "returns the team user" do
        controller.sign_in(default_user)
        controller.sign_in(user_with_several_teams)

        assert_equal user_with_several_teams, available_users.user_signed_in_on_another_subdomain(user_with_several_teams_team)
      end
    end

    context "there is no team user signed in on another team subdomain" do
      it "returns nil" do
        assert_nil available_users.user_signed_in_on_another_subdomain(user_with_several_teams_team)
      end
    end
  end

  describe "#sign out" do
    it "invalidates all user session on the device" do
      controller.sign_in(default_user)

      Authie::Session.where(user: default_user, active: true).each do |session|
        session.expects(:invalidate!)
      end

      controller.sign_out(default_user)
    end
  end
end
