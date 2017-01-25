require "test_helper"

describe User::Email::SendConfirmationInstructions, :controller do
  subject { User::Email::SendConfirmationInstructions }
  let(:user) { users(:with_unconfirmed_email) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }

  describe "#call" do
    it "sends confirmation mail" do
      CustomDeviseMailer.expects(:confirmation_instructions)
                        .with(user, user.confirmation_token, "confirmation_url")

      assert subject.call(user: user, controller: controller).success?
    end

    it "saves email sent at time" do
      assert subject.call(user: user, controller: controller).success?
      user.reload

      assert_not_nil user.confirmation_sent_at
    end
  end
end
