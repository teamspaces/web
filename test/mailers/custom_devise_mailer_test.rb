require "test_helper"

describe CustomDeviseMailer do
  let(:user) { users(:lars) }

  describe "#confirmation_instructions" do
    let(:options) { { confirmation_url: "http://what.lvh.me/users/confirmation?confirmation_token=fake_token"} }

    describe "confirmation instructions" do
      it "works" do
        mail = CustomDeviseMailer.confirmation_instructions(user, "fake_token", options)
        html_body = mail.message.body.decoded

        assert_includes html_body, user.first_name
        assert_includes html_body, "users/confirmation?confirmation_token=fake_token"
      end
    end

    describe "reconfirmation instructions" do
      it "works" do
        mail = CustomDeviseMailer.confirmation_instructions(user, "fake_token", options)
        html_body = mail.message.body.decoded

        assert_includes html_body, user.first_name
        assert_includes html_body, "users/confirmation?confirmation_token=fake_token"
      end
    end

    describe "#reset_password_instructions" do
      it "works" do
        mail = CustomDeviseMailer.reset_password_instructions(user, "fake_token", options)
        html_body = mail.message.body.decoded

        assert_includes html_body, user.first_name
        assert_includes html_body, "a lo oest"
      end
    end

    describe "#password_change" do
      it "works" do
        mail = CustomDeviseMailer.password_change(user, options)
        html_body = mail.message.body.decoded

        assert_includes html_body, user.first_name
      end
    end
  end
end
