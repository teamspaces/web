require 'test_helper'

describe UserAfterSignInPath, :controller do

  context "user without teams" do
    it "redirects to create team" do
      sign_in users(:without_team)
      get new_user_session_path

      assert_redirected_to new_team_url(subdomain: "")
    end
  end

  context "user with team" do
    let(:user_with_one_team) { users(:lars) }
    let(:team) { user_with_one_team.teams.first }
    let(:auth_token) { "encoded"}

    it "redirects to team" do
      GenerateLoginToken.expects(:call).with(user: user_with_one_team).returns(auth_token)
      sign_in user_with_one_team
      get new_user_session_path

      assert_redirected_to team_url(subdomain: team.subdomain, auth_token: auth_token)
    end
  end

  context "user with several teams" do
    it "redirects to teams" do
      sign_in users(:with_several_teams)
      get new_user_session_path

      assert_redirected_to teams_url(subdomain: "")
    end
  end
end
