require "test_helper"

describe User::EmailConfirmation, :model do

  describe "#email_confirmation_required?" do
    describe "email user" do
      context "with unconfirmed mail" do
        it "returns true" do
          assert users(:with_unconfirmed_email).email_confirmation_required?
        end
      end

      context "with new unconfirmed mail" do
        it "returns true" do
          assert users(:with_new_unconfirmed_email).email_confirmation_required?
        end
      end

      context "with confirmed mail" do
        it "returns false" do
          refute users(:ulf).email_confirmation_required?
        end
      end
    end

    describe "slack user" do
      it "returns false" do
        refute users(:slack_user_milad).email_confirmation_required?
      end
    end
  end

  describe "email gets updated before ever confirmed" do
    it "sends email confirmation instructions, with new confirmation token" do
      user = users(:with_unconfirmed_email)
      old_confirmation_token = user.confirmation_token

      CustomDeviseMailer.expects(:confirmation_instructions)
                        .with { |user, token| token != old_confirmation_token }
                        .returns(mailer_mock = mock).once

      mailer_mock.stubs(:deliver_later).returns(true)

      user.update(email: "updated@email.com")
      assert_not_equal old_confirmation_token, user.confirmation_token
    end
  end

  describe "sends email confirmation instructions" do
    describe "email user" do
      context "on creation" do
        it "sends email confirmation instructions" do
          User.any_instance.expects(:send_confirmation_instructions).once

          User.create(email: "email_user@nl.com", password: "secure", allow_email_login: true)
        end
      end

      describe "on update" do
        context "confirmed email" do
          it "sends email confirmation instructions" do
            User.any_instance.expects(:send_confirmation_instructions).once

            users(:ulf).update(email: "updated@email.com")
          end
        end

        context "not confirmed email" do
          it "sends email confirmation instructions" do
            User.any_instance.expects(:send_confirmation_instructions).once

            users(:with_unconfirmed_email).update(email: "updated@email.com")
          end
        end
      end
    end

    describe "slack user" do
      it "does not send email confirmation instructions" do
        User.any_instance.expects(:send_confirmation_instructions).never

        User.create(email: "email_user@nl.com", allow_email_login: false)
      end
    end
  end

  describe "it pospones email update" do
    describe "email user" do
      context "with confirmed email" do
        it "does postpone email update" do
          users(:ulf).update(email: "new_email@ne.es")

          assert_equal "new_email@ne.es", users(:ulf).unconfirmed_email
        end
      end

      context "with new unconfirmed email" do
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
      end
    end
  end
end

