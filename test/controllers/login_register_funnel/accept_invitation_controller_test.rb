require "test_helper"

describe LoginRegisterFunnel::AcceptInvitationController do

  describe "#new" do
    describe "valid invitation" do
      let(:valid_invitation) { invitations(:jonas_at_spaces) }

      it "sets invitation-token cookie" do
        get accept_invitation_url(valid_invitation.token, subdomain: ENV["DEFAULT_SUBDOMAIN"])

        assert cookies["invitation_token"]
      end

      describe "slack invitation" do
        let(:slack_invitation) { invitations(:slack_user_spaces_invitation) }

        it "redirects to slack register path" do
          get accept_invitation_url(slack_invitation.token, subdomain: ENV["DEFAULT_SUBDOMAIN"])

          assert_redirected_to slack_register_path
        end
      end

      describe "email invitation" do
        let(:email_invitation) { invitations(:jonas_at_spaces) }

        it "sets invited email address as reviewed during login register funnel" do
          get accept_invitation_url(email_invitation.token, subdomain: ENV["DEFAULT_SUBDOMAIN"])

          assert_equal email_invitation.email, session[:users_reviewed_email_address]
        end

        context "email is already registered" do
          let(:email_invitation_already_registered) { invitations(:katharina_at_power_rangers) }

          it "redirects to email login path" do
            get accept_invitation_url(email_invitation_already_registered.token, subdomain: ENV["DEFAULT_SUBDOMAIN"])

            assert_redirected_to email_login_path
          end
        end

        context "email is new" do
          let(:email_invitation_is_new) { invitations(:jonas_at_spaces) }

          it "redirects to email register path" do
             get accept_invitation_url(email_invitation_is_new.token, subdomain: ENV["DEFAULT_SUBDOMAIN"])

             assert_redirected_to email_register_path
          end
        end
      end
    end

    describe "invalid invitation" do
      describe "invitation does not exist" do
        let(:invalid_invitation_token) { "invalid_invitation_token" }

        it "redirects to landing path with notice" do
          get accept_invitation_url(invalid_invitation_token, subdomain: ENV["DEFAULT_SUBDOMAIN"])

          assert_redirected_to landing_path
          assert_equal "Unfortunately your invitation was withdrawn", flash[:notice]
        end
      end

      describe "invitation was already used" do
        let(:accepted_invitation) { invitations(:accepted_invitation) }

        it "redirects to landing path with notice" do
          get accept_invitation_url(accepted_invitation.token, subdomain: ENV["DEFAULT_SUBDOMAIN"])

          assert_redirected_to landing_path
          assert_match "This invitation was already used. Please continue with", flash[:notice]
        end
      end
    end
  end
end
