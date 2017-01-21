require "test_helper"

describe User::EmailConfirmation, :model do
  let(:email_user) { users(:ulf) }
  let(:slack_user) { users(:slack_user_milad) }

  describe "#email_confirmation_required?" do
    context "email confirmed" do
      let(:user_with_confirmed_email) { users(:ulf) }

      it "returns false" do
        refute user_with_confirmed_email.email_confirmation_required?
      end
    end

    context "email not confirmed" do
      let(:user_email_not_confirmed) { users(:email_not_yet_confirmed) }

      it "returns true" do
        assert user_email_not_confirmed.email_confirmation_required?
      end
    end

    context "new email not confirmed" do
      let(:user_with_new_unconfirmed_email) { users(:with_unconfirmed_email) }

      it "returns true" do
        assert user_with_new_unconfirmed_email.email_confirmation_required?
      end
    end
  end

  describe "#confirmation_required?" do
    context "email user" do
      it "returns true" do
        assert email_user.send(:confirmation_required?)
      end
    end

    context "slack user" do
      it "returns false" do
        refute slack_user.send(:confirmation_required?)
      end
    end
  end

  describe "#postpone_email_change?" do
    context "email user" do
      it "returns true" do
        assert email_user.send(:postpone_email_change?)
      end
    end

    context "slack user" do
      it "returns false" do
        refute slack_user.send(:postpone_email_change?)
      end
    end
  end

  describe "#reconfirmation_required?" do
    context "email user" do
      it "returns true" do
        assert email_user.send(:reconfirmation_required?)
      end
    end

    context "slack user" do
      it "returns false" do
        refute slack_user.send(:reconfirmation_required?)
      end
    end
  end
end

