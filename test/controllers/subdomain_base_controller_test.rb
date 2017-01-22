require 'test_helper'

describe SubdomainBaseController do
  let(:spaces_user) { users(:lars) }
  let(:spaces_team) { teams(:spaces) }
  let(:power_rangers_team) { teams(:power_rangers) }

  before(:each) { sign_in spaces_user }

  describe "team subdomain check" do
    context "current_user is member of team" do
      it "shows content" do
        get team_url(subdomain: spaces_team.subdomain)

        assert_response :success
      end
    end

    context "current_user is not member of team" do
      it "redirects to landing page without subdomain" do
        get team_url(subdomain: power_rangers_team.subdomain)

        assert_redirected_to root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
      end
    end
  end

  describe "#check_email_confirmation" do
    context "user confirmed email" do
      it "allows access" do
        get team_url(subdomain: spaces_team.subdomain)

        assert_response :success
      end
    end

    context "user needs to confirm email" do
      let(:user_with_unconfirmed_email) { users(:with_unconfirmed_email) }

      it "redirects to new_user_email_confirmation_path" do
        sign_in user_with_unconfirmed_email

        get team_url(subdomain: user_with_unconfirmed_email.teams.first.subdomain)

        assert_redirected_to new_user_email_confirmation_path
      end
    end
  end
end
