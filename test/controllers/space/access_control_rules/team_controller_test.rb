require "test_helper"

describe Space::AccessControlRules::TeamController do
  let(:user) { users(:ulf) }
  let(:team) { user.teams.first }
  let(:space) { team.spaces.first }
  before(:each) { sign_in user }

  describe "#create" do
    it "creates a team access control for space" do
      post space_access_control_rules_team_url(space, subdomain: team.subdomain)

      assert_equal Space::AccessControlRules::TEAM, space.reload.access_control_rule
    end

    it "redirects to space members path" do
      post space_access_control_rules_team_url(space, subdomain: team.subdomain)

      assert_redirected_to space_members_path(space)
    end
  end
end
