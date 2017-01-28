require 'test_helper'

describe SubdomainBaseController do
  let(:spaces_user) { users(:lars) }
  let(:spaces_team) { teams(:spaces) }
  let(:power_rangers_team) { teams(:power_rangers) }

  before(:each) { sign_in spaces_user }

  describe "verify team membership" do
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

  describe "verify email confirmed" do
    context "user confirmed email" do
      it "allows access" do
        get team_url(subdomain: spaces_team.subdomain)

        assert_response :success
      end
    end

    describe "user needs to confirm email" do
      let(:user_with_unconfirmed_email) { users(:with_unconfirmed_email) }
      before(:each) { sign_in user_with_unconfirmed_email }

      it "redirects to new_user_email_confirmation_path" do
        get team_url(subdomain: user_with_unconfirmed_email.teams.first.subdomain)

        assert_redirected_to new_user_email_confirmation_path
      end

      context "email confirmation was not yet send" do
        it "sends email confirmation" do
          User::Email::SendConfirmationInstructions.expects(:call).once

          get team_url(subdomain: user_with_unconfirmed_email.teams.first.subdomain)
        end
      end

      context "email confirmation was already send" do
        it "does not send email confirmation" do
          user_with_unconfirmed_email.update(confirmation_sent_at: Time.now)
          User::Email::SendConfirmationInstructions.expects(:call).never

          get team_url(subdomain: user_with_unconfirmed_email.teams.first.subdomain)
        end
      end
    end
  end
end
