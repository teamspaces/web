require "test_helper"

describe LoginRegisterFunnel::LoginIntoTeamController, :controller do

  describe "#login_on_subdomain_uncertain_if_user_authenticated" do
    describe "user already signed in on team subdomain" do
      let(:user) { users(:lars) }
      before(:each) { sign_in(user) }

      it "redirects to team path" do
        get login_into_team_url(subdomain: user.teams.first.subdomain)

        assert_redirected_to team_path
      end
    end

    describe "user not signed in on team subdomain" do
      describe "email user" do
        let(:email_user) { users(:ulf) }

        it "redirects to email login" do
          LoginRegisterFunnel::BaseController::AvailableUsersCookie.any_instance.stubs(:users).returns([email_user])
          get login_into_team_url(subdomain: email_user.teams.first.subdomain)

          assert_redirected_to new_email_login_path
        end
      end

      describe "slack user" do
        let(:slack_user) { users(:slack_user_milad) }
        let(:team) { slack_user.teams.first }

        it "redirects to slack login, with team to login set in callback" do
          LoginRegisterFunnel::BaseController::AvailableUsersCookie.any_instance.stubs(:users).returns([slack_user])
          get login_into_team_url(subdomain: team.subdomain)

          assert_redirected_to user_slack_omniauth_authorize_url(subdomain: ENV["DEFAULT_SUBDOMAIN"],
                                                                 state: :login, team_id: team.id)
        end
      end
    end
  end

  describe "#login_to_subdomain_for_authenticated_user" do
    describe "authenticated user" do
      context "user has access to team" do
        it "signs user in into team subdomain" do

        end
      end

      context "user has no access to team" do
        it "redirects to subdomain, no auto login" do

        end
      end
    end

    describe "user not authenticated" do
      it "redirects to default subdomain root" do

      end
    end
  end
end
