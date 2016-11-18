require 'test_helper'

describe SubdomainBaseController do
  let(:furrow_user) { users(:lars) }
  let(:furrow_team) { teams(:furrow) }
  let(:power_rangers_team) { teams(:power_rangers) }

  before(:each) { sign_in furrow_user }

  describe "team subdomain check" do
    context "current_user is member of team" do
      it "shows content" do
        get team_url(subdomain: furrow_team.name)

        assert_response :success
      end
    end

    context "current_user is not member of team" do
      it "redirects to landing page without subdomain" do
        get team_url(subdomain: power_rangers_team.name)

        assert_redirected_to landing_url(subdomain: "")
      end
    end
  end
end
