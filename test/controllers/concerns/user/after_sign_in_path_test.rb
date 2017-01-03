require 'test_helper'

describe User::AfterSignInPath, :controller do

  context "user with team" do
    let(:user_with_one_team) { users(:lars) }
    let(:team) { user_with_one_team.teams.first }
    let(:auth_token) { "encoded"}

    context "on team subdomain" do
      it "redirects to team without authentication token" do
        sign_in user_with_one_team
        get new_user_session_url(subdomain: team.subdomain)

        assert_redirected_to team_url(subdomain: team.subdomain)
      end
    end

    context "other than team subdomain" do
      it "redirects to team with authentication token" do
        GenerateLoginToken.expects(:call).with(user: user_with_one_team).returns(auth_token)
        sign_in user_with_one_team
        get new_user_session_path

        assert_redirected_to team_url(subdomain: team.subdomain, auth_token: auth_token)
      end
    end
  end

  context "user with several teams" do
    let(:user_with_several_teams) { users(:with_several_teams) }
    let(:team) { user_with_several_teams.teams.first }

    context "on team subdomain" do
      it "redirects to team without authentication token" do
        sign_in user_with_several_teams
        get new_user_session_url(subdomain: team.subdomain)

        assert_redirected_to root_subdomain_url(subdomain: team.subdomain)
      end
    end
  end
end
