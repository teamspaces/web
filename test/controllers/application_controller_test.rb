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

  describe "#after_sign_out_path_for" do
    it "redirects to landing page" do
      sign_in_user

      delete destroy_user_session_path

      assert_redirected_to landing_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
  end
end
