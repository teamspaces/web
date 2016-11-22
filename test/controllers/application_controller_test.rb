require 'test_helper'

describe ApplicationController do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:furrow_team_url) { team_url(subdomain: team.subdomain) }
  let(:auth_token) { "secret_token" }

  context "not signed in" do
    it "redirects" do
        get furrow_team_url
        assert_redirected_to new_user_session_path
    end
  end

  context "signed in" do
    it "shows content" do
      sign_in_user

      get furrow_team_url
      assert_response :success
    end
  end

  describe "auth token param" do
    context "valid" do
      it "signs in user" do
        get landing_url(auth_token: GenerateLoginToken.call(user: user))

        assert_equal user, controller.current_user
      end
    end
  end

  describe "#after_sign_in_path_for" do
    context "user without teams" do
      it "redirects to create team" do
        sign_in users(:without_team)

        get new_user_session_path

        assert_redirected_to new_team_url(subdomain: "")
      end
    end

    context "user with team" do
      it "redirects to team" do
        GenerateLoginToken.expects(:call).with(user: user).returns(auth_token)

        sign_in user

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

  describe "#after_sign_out_path_for" do
    it "redirects to landing page" do
      sign_in_user

      delete destroy_user_session_path

      assert_redirected_to landing_url(subdomain: "")
    end
  end
end
