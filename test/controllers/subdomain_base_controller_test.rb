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

  describe "#new" do
    describe "user already signed in on team subdomain" do
      let(:user) { users(:lars) }
      before(:each) { sign_in(user) }

      it "redirects to team path" do
        get root_subdomain_url(subdomain: user.teams.first.subdomain)

        assert_redirected_to team_path
      end
    end

    describe "user not signed in on team subdomain" do
      describe "email user" do
        let(:email_user) { users(:ulf) }

        it "redirects to email login" do
          LoginRegisterFunnel::BaseController::AvailableUsersCookie.any_instance.stubs(:users).returns([email_user])
          get root_subdomain_url(subdomain: email_user.teams.first.subdomain)

          assert_redirected_to new_email_login_path
        end
      end

      describe "slack user" do
        let(:slack_user) { users(:slack_user_milad) }
        let(:team) { slack_user.teams.first }

        it "redirects to slack login, with team to login set in callback" do
          LoginRegisterFunnel::BaseController::AvailableUsersCookie.any_instance.stubs(:users).returns([slack_user])
          get root_subdomain_url(subdomain: team.subdomain)

          assert_redirected_to user_slack_omniauth_authorize_url(subdomain: ENV["DEFAULT_SUBDOMAIN"],
                                                                 state: :login, team_id: team.id)
        end
      end
    end
  end
end
