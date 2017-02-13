require "test_helper"

describe Space::AccessControl::TeamController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:space) { spaces(:spaces) }
  before(:each) { sign_in user }

  describe "#create" do
    it "creates a team access control for space" do
      post space_access_control_team_url(space, subdomain: team.subdomain)

      assert space.access_control.team?
    end

    it "redirects to space members path" do
      post space_access_control_team_url(space, subdomain: team.subdomain)

      assert_redirected_to space_members_path(space)
    end
  end
end
