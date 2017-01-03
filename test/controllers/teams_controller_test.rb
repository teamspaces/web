require 'test_helper'

describe TeamsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:auth_token) { "secret_token" }

  before(:each) { sign_in user }

  describe "#show" do
    context "user is team member" do
      it "works" do
        get team_url(subdomain: team.subdomain)
        assert_response :success
      end
    end

    context "user is not team member" do
      it "refutes access" do
        sign_in users(:without_team)
        get team_url(subdomain: team.subdomain)

        assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end

  describe "#edit" do
    it "works" do
      get edit_team_url(subdomain: team.subdomain)

      assert_response :success
    end
  end

  describe "#update" do
    it "works" do
      new_team_name = "Southside Security PLC"
      patch team_url(subdomain: team.subdomain), params: { team: { name: new_team_name } }

      team.reload
      assert_equal new_team_name, team.name
    end
  end

  describe "#destroy" do
    it "works" do
      assert_difference -> { Team.count }, -1 do
        delete team_url(subdomain: team.subdomain)
      end
    end
  end
end
