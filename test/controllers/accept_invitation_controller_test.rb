require "test_helper"

describe AcceptInvitationController do

  describe "#new" do
    describe "valid invitation" do
      describe "email_invitation" do
        let(:email_invitation_for_registered_user) { invitations(:katharina_at_power_rangers) }
        let(:email_invitation_for_new_user) { invitations(:jonas_at_spaces) }

        context "user already registered" do
          it "it redirects to login with email" do
            get accept_invitation_path(email_invitation_for_registered_user.token)

            assert_redirected_to new_email_login_path
          end
        end

        context "new user" do
          it "redirects to register with email" do
            get accept_invitation_path(email_invitation_for_new_user.token)

            assert_redirected_to new_email_register_path
          end
        end

        it "sets invitation cookie from params" do
          AcceptInvitationController.any_instance.expects(:set_invitation_cookie_from_params)

          get accept_invitation_path(email_invitation_for_registered_user.token)
        end
      end

      describe "slack_invitation" do
        let(:slack_invitation) { invitations(:slack_user_spaces_invitation) }

        it "redirects to slack_register_path" do
          get accept_invitation_path(slack_invitation.token)

          assert_redirected_to slack_register_path
        end
      end
    end

    describe "invitation already accepted" do
      let(:accepted_invitation) { invitations(:accepted_invitation) }

      it "redirects to landing_path with notice" do
        get accept_invitation_path(accepted_invitation.token)

        assert_redirected_to landing_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
        assert_equal I18n.t("invitation_already_accepted"), flash[:notice]
      end
    end

    describe "invalid invitation" do
      let(:invalid_invitation_token) { "invalid_invitation_token"}

      it "redirects to landing_path with notice" do
        get accept_invitation_path(invalid_invitation_token)

        assert_redirected_to landing_url(subdomain: ENV["DEFAULT_SUBDOMAIN"])
        assert_equal I18n.t("invitation_does_not_exist"), flash[:notice]
      end
    end
  end
end
