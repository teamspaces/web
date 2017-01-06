require "test_helper"

describe LoginRegisterFunnel::LoginIntoTeamController, :controller do

  describe "#new" do
    describe "user already signed in on team subdomain" do
      let(:user){users(:lars)}
      before(:each){sign_in(user)}

      it "redirects to team path" do
        get login_into_team_url(subdomain: user.teams.first.subdomain)

        assert_redirected_to team_path
      end
    end

    describe "user not signed in on team subdomain" do
      describe "email user" do
        let(:email_user){users(:ulf)}
        before(:each){DeviceUsersCookie.new(cookies).add(email_user)}

        it "redirects to email login" do
          get login_into_team_url(subdomain: email_user.teams.first.subdomain)

          assert_redirected_to new_email_login_path
        end
      end

      describe "slack user" do
        let(:slack_user){users(:slack_user_milad)}
        let(:team){slack_user.teams.first}
        before(:each){DeviceUsersCookie.new(cookies).add(slack_user)}

        it "redirects to slack login" do
          get login_into_team_url(subdomain: team.subdomain)

          assert_redirected_to user_slack_omniauth_authorize_url(subdomain: ENV["DEFAULT_SUBDOMAIN"],
                                                                 state: :login, team_id: team.id)
        end
      end
    end
  end
end
