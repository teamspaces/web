require 'test_helper'

describe ApplicationController do
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
end
