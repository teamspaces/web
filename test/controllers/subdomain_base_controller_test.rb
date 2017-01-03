require 'test_helper'

describe SubdomainBaseController do
  let(:spaces_user) { users(:lars) }
  let(:spaces_team) { teams(:spaces) }
  let(:power_rangers_team) { teams(:power_rangers) }

  before(:each) { sign_in spaces_user }

  describe "team subdomain check" do
    context "current_user is member of team" do
      it "shows content" do
        get team_url(subdomain: spaces_team.subdomain)

        assert_response :success
      end
    end

    context "current_user is not member of team" do
      it "redirects to landing page without subdomain" do
        get team_url(subdomain: power_rangers_team.subdomain)

        assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end
end
