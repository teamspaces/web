require 'test_helper'

describe ApplicationController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:spaces_team_url) { team_url(subdomain: team.subdomain) }

  context "not signed in" do
    it "redirects to root_url" do
      get spaces_team_url
      assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
  end

  context "signed in" do
    it "shows content" do
      sign_in users(:ulf)

      get spaces_team_url
      assert_response :success
    end
  end

  describe "#after_sign_out_path_for" do
    it "redirects to landing page" do
      sign_in users(:ulf)
      delete destroy_user_session_path

      assert_redirected_to root_url(subdomain:  ENV["DEFAULT_SUBDOMAIN"])
    end
  end
end
