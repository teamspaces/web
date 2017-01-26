require "test_helper"

describe User::Email::SendConfirmationInstructions, :controller do
  subject { User::Email::SendConfirmationInstructions }
  let(:user) { users(:with_unconfirmed_email) }
  let(:controller) do
    sign_in user
    get root_subdomain_url(subdomain: user.teams.first.subdomain)
    @controller
  end

  describe "#call" do
    it "sends confirmation mail" do
      CustomDeviseMailer.expects(:confirmation_instructions)
                        .with(user,
                              user.confirmation_token,
                              { confirmation_url: "http://what.example.com/?confirmation_token=23skokoi9hunun89h8h" })

      assert subject.call(user: user, controller: controller).success?
    end

    it "saves email sent at time" do
      assert subject.call(user: user, controller: controller).success?
      user.reload

      assert_not_nil user.confirmation_sent_at
    end
  end
end
