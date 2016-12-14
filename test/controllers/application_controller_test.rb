require 'test_helper'

describe ApplicationController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:spaces_team_url) { team_url(subdomain: team.subdomain) }

  context "not signed in" do
    it "redirects" do
        get spaces_team_url
        assert_redirected_to new_user_session_path
    end
  end

  context "signed in" do
    it "shows content" do
      sign_in_user

      get spaces_team_url
      assert_response :success
    end
  end

  describe "#after_sign_out_path_for" do
    it "redirects to landing page" do
      sign_in_user
      delete destroy_user_session_path

      assert_redirected_to landing_path
    end
  end
end
