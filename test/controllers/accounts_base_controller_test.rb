require 'test_helper'

describe ApplicationController do
  let(:user) { users(:lars) }
  let(:accounts_base_controller_url) { team_new_teams_url(subdomain: ENV["ACCOUNTS_SUBDOMAIN"]) }

  context "not signed in" do
    it "redirects to root_url" do
      get accounts_base_controller_url
      assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
    end
  end

  context "signed in" do
    it "shows content" do
      sign_in user

      get accounts_base_controller_url
      assert_response :success
    end
  end
end
