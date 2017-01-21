require "test_helper"

describe CustomDeviseMailer do

  describe "#confirmation_instructions" do
    context "confirmation instructions" do
      let(:user_with_unconfirmed_email) { users(:with_unconfirmed_email) }

      it "works" do
        mail = CustomDeviseMailer.confirmation_instructions(user_with_unconfirmed_email, "fake_token", {})
        html_body = mail.message.body.decoded

        assert_includes html_body, user_with_unconfirmed_email.first_name
        assert_includes html_body, "users/confirmation?confirmation_token=fake_token"
      end
    end

    context "reconfirmation instructions" do
      let(:user_with_new_unconfirmed_email) { users(:with_new_unconfirmed_email) }

      it "works" do
        mail = CustomDeviseMailer.confirmation_instructions(user_with_new_unconfirmed_email, "fake_token", {})
        html_body = mail.message.body.decoded

        assert_includes html_body, user_with_unconfirmed_email.first_name
        assert_includes html_body, "users/confirmation?confirmation_token=fake_token"
      end
    end
  end
end
