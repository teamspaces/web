require 'test_helper'

describe LoginRegisterFunnel::BaseController::AvailableUsersCookie, :controller do
  let(:default_user) { users(:ulf) }
  let(:user_with_several_teams){ users(:with_several_teams) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:available_users_cookie) { LoginRegisterFunnel::BaseController::AvailableUsersCookie.new(controller.send(:cookies)) }

  describe "#users" do
    it "returns all users with an active session" do
      controller.sign_in(default_user)

      assert_includes available_users_cookie.users, default_user
      assert_not_includes available_users_cookie.users, user_with_several_teams
    end
  end

  describe "#teams" do
    it "returns all teams of all users with an active session" do
      controller.sign_in(user_with_several_teams)

      user_with_several_teams.teams.each do |team|
        assert_includes available_users_cookie.teams, team
      end
    end
  end
end
