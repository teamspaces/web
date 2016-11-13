require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  let(:user) { users(:lars) }

  before(:each) do
    sign_in user
  end

  context "#create" do
    it "creates team" do
      post :create, params: { team: { name: "google" } }

      team = Team.last
      assert_equal "google", team.name
    end

    it "makes creator primary owner" do
      post :create, params: { team: { name: "google" } }

      team_member = Team.last.team_members.last
      assert_equal user, team_member.user
      assert team_member.primary_owner?
    end
  end
end
