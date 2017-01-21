require "test_helper"

describe User::EmailConfirmation, :model do

  describe "#email_confirmation_required?" do
    describe "email user" do
      let(:user_with_unconfirmed_email) { users(:with_unconfirmed_email) }
      let(:user_with_confirmed_email) { users(:ulf) }

      context "email not confirmed" do
        it "returns true" do
          assert user_with_unconfirmed_email.email_confirmation_required?
        end
      end

      context "email confirmed" do
        it "returns false" do
          refute user_with_confirmed_email.email_confirmation_required?
        end
      end
    end

    describe "slack user" do
      let(:slack_user) { users(:slack_user_milad) }

      it "returns false" do
        refute slack_user.email_confirmation_required?
      end
    end

    describe "on creation" do
      context "email user" do
        it "returns true" do
          email_user = User.create(email: "email_user@nl.com", allow_email_login: true)

          assert email_user.email_confirmation_required?
        end
      end

      context "slack user" do
        it "returns false" do
          slack_user = User.create(email: "slack_user@nl.com", allow_email_login: false)

          refute slack_user.email_confirmation_required?
        end
      end
    end

    describe "on update" do
      describe "email user" do
        describe "has already email confirmed" do
          let(:user_with_confirmed_email) { users(:ulf) }
          before(:each) do
            user_with_confirmed_email.email = "updated_email@amsterdam.com"
            user_with_confirmed_email.save
          end

          it "returns true" do
            assert user_with_confirmed_email.email_confirmation_required?
          end

          it "postpones email update" do
            assert_equal "ulf@spaces.is", user_with_confirmed_email.email
            assert_equal "updated_email@amsterdam.com", user_with_confirmed_email.unconfirmed_email
          end
        end

        describe "email not yet confirmed" do
          let(:user_with_unconfirmed_email) { users(:with_unconfirmed_email) }
          before(:each) do
            user_with_unconfirmed_email.email = "updated_email@amsterdam.com"
            user_with_unconfirmed_email.save
          end

          it "returns true" do
            assert user_with_unconfirmed_email.email_confirmation_required?
          end

          it "does not postpone email update" do
            assert_equal "updated_email@amsterdam.com", user_with_unconfirmed_email.email
            assert_nil user_with_unconfirmed_email.unconfirmed_email
          end
        end
      end

      describe "slack user" do
        let(:slack_user) { users(:slack_user_milad) }
        before(:each) do
          slack_user.email = "updated_email@amsterdam.com"
          slack_user.save
        end

        it "returns false" do
          refute slack_user.email_confirmation_required?
        end

        it "does not postpone email update" do
          assert_equal "updated_email@amsterdam.com", slack_user.email
          assert_nil slack_user.unconfirmed_email
        end
      end
    end
  end
end

