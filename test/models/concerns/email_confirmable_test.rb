require "test_helper"

describe EmailConfirmable, :model do
  let(:user_with_confirmed_email) { users(:ulf) }
  let(:user_with_unconfirmed_email) { users(:with_unconfirmed_email) }
  let(:confirmed_user_with_new_unconfirmed_email) { users(:with_new_unconfirmed_email) }
  let(:slack_user) { users(:slack_user_milad) }

  describe "#email_confirmation_required?" do
    describe "email user" do
      context "with unconfirmed mail" do
        it "returns true" do
          assert user_with_unconfirmed_email.email_confirmation_required?
        end
      end

      context "confirmed user, with new unconfirmed mail" do
        it "returns true" do
          assert confirmed_user_with_new_unconfirmed_email.email_confirmation_required?
        end
      end

      context "with confirmed mail" do
        it "returns false" do
          refute user_with_confirmed_email.email_confirmation_required?
        end
      end
    end

    describe "slack user" do
      it "returns false" do
        refute slack_user.email_confirmation_required?
      end
    end
  end

  describe "email update" do
    describe "email user" do
      context "with confirmed email" do
        it "does postpone email update" do
          confirmed_email = user_with_confirmed_email.email

          user_with_confirmed_email.update(email: "new_email@ne.es")
          user_with_confirmed_email.reload

          assert_equal confirmed_email, user_with_confirmed_email.email
          assert_equal "new_email@ne.es", user_with_confirmed_email.unconfirmed_email
          assert_nil user_with_confirmed_email.confirmation_sent_at
        end

        it "generates new confirmation token" do
          confirmation_token = user_with_confirmed_email.confirmation_token
          user_with_confirmed_email.update(email: "new_email@ne.es")

          assert_not_equal confirmation_token, user_with_confirmed_email.confirmation_token
        end
      end

      context "confirmed user, with new unconfirmed email" do
        it "does postpone email update" do
          users(:with_new_unconfirmed_email).update(email: "new_email@ne.es")

          assert_equal "new_email@ne.es", users(:with_new_unconfirmed_email).unconfirmed_email
        end
      end

      context "with unconfirmed email" do
        it "does not postpone email update" do
          users(:with_unconfirmed_email).update(email: "new_email@ne.es")

          assert_equal "new_email@ne.es", users(:with_unconfirmed_email).email
        end
      end
    end

    describe "slack user" do
      it "does not pospone email update" do
        users(:slack_user_milad).update(email: "new_address@slack.com")
        users(:slack_user_milad).reload

        assert_equal "new_address@slack.com", users(:slack_user_milad).email
        assert_nil users(:slack_user_milad).unconfirmed_email
      end
    end
  end
end

