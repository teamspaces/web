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
          it "sends email confirmation  instructions" do
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

    end

    describe "slack user" do
      it "does not pospone email update" do

      end
    end
  end
end

