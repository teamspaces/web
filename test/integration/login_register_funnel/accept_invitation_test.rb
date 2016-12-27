require "test_helper"

describe "Accept Invitation", :integration do
  include TestHelpers::SubdomainHelper

  describe "slack invitation" do
    let(:slack_invitation) { invitations(:slack_user_spaces_invitation) }

    it "user gets redirected to slack register" do
      visit "/accept_invitation/#{slack_invitation.token}"

      assert current_url.include? slack_register_path
    end
  end

  describe "email invitation" do
    context "invited user is not yet registered" do
      let(:email_invitation_new) { invitations(:jonas_at_spaces) }

      it "user registers, automatically accepts invitation and gets redirects to team" do
        visit "/accept_invitation/#{email_invitation_new.token}"

        assert current_url.include? new_email_register_path

        fill_in("First name", with: "Max")
        fill_in("Last name", with: "Mustermann")
        fill_in("Password", with: "password")
        fill_in("Password confirmation", with: "password")
        find('input[name="commit"]').click

        assert current_url.include? team_url({subdomain: email_invitation_new.team.subdomain}.merge(url_options))
        assert_includes email_invitation_new.team.users.map(&:email), email_invitation_new.email
      end
    end

    context "invited user is already registered" do
      let(:accepting_user) { users(:without_team) }
      let(:email_invitation) { invitations(:katharina_at_power_rangers) }

      it "user logins, automatically accepts invitation and gets redireced to team" do
        visit "/accept_invitation/#{email_invitation.token}"

        assert current_url.include? new_email_login_path
        fill_in("Password", with: "password")
        click_on "Login with my account"

        assert current_url.include? team_url({subdomain: email_invitation.team.subdomain}.merge(url_options))
        assert_includes email_invitation.team.users, accepting_user
      end
    end
  end
end
