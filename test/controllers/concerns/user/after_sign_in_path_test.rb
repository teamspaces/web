require 'test_helper'

describe User::AfterSignInPath, :controller do
  describe "user without teams" do
    let(:user_without_team) { users(:without_team) }

    it "redirects to create team" do
      sign_in user_without_team
      get new_user_session_path

      assert_redirected_to new_team_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
  end

  describe "user with team" do
    let(:user_with_one_team) { users(:lars) }
    let(:team) { user_with_one_team.teams.first }
    let(:auth_token) { "encoded" }

    describe "on team subdomain" do
      it "redirects to team without authentication token" do

        sign_in user_with_one_team
        get new_user_session_url(subdomain: team.subdomain)

        assert_redirected_to team_url(subdomain: team.subdomain)
      end
    end

    describe "other than team subdomain" do
      it "redirects to team with authentication token" do
        GenerateLoginToken.expects(:call).with(user: user_with_one_team).returns(auth_token)
        sign_in user_with_one_team
        get new_user_session_path

        assert_redirected_to team_url(subdomain: team.subdomain, auth_token: auth_token)
      end
    end
  end

  describe "user with several teams" do
    let(:user_with_several_teams) { users(:with_several_teams) }
    let(:team) { user_with_several_teams.teams.first }

    describe "on team subdomain" do
      it "redirects to team without authentication token" do
        sign_in user_with_several_teams
        get new_user_session_url(subdomain: team.subdomain)

        assert_redirected_to root_subdomain_url(subdomain: team.subdomain)
      end
    end

    describe "other than team subdomain" do
      it "redirects to teams" do
        sign_in users(:with_several_teams)
        get new_user_session_path

        assert_redirected_to teams_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end
end
