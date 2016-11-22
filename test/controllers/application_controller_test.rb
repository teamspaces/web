require 'test_helper'

describe ApplicationController do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }
  let(:furrow_team_url) { team_url(subdomain: team.subdomain) }

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
end
