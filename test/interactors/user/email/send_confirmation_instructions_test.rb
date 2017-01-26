require "test_helper"

describe User::Email::SendConfirmationInstructions, :controller do
  subject { User::Email::SendConfirmationInstructions }
  let(:unconfirmed_user) { users(:with_unconfirmed_email) }
  let(:mailer_mock) do
    mailer_mock = mock()
    mailer_mock.stubs(:deliver_later).returns(true)
    mailer_mock
  end
  before(:each) do
    sign_in unconfirmed_user
    get team_url(subdomain: unconfirmed_user.teams.first.subdomain)
  end

  describe "#call" do
    describe "current_url can be used as email link for confirmation" do
      it "sends confirmation mail, with link to current url" do
        CustomDeviseMailer.expects(:confirmation_instructions)
                          .with(unconfirmed_user, unconfirmed_user.confirmation_token,
                                {confirmation_url: "http://spaces.example.com/team?confirmation_token=#{unconfirmed_user.confirmation_token}"})
                          .returns(mailer_mock)

        assert subject.call(user: unconfirmed_user, controller: @controller).success?
      end
    end

    it "saves email sent at time" do
      assert subject.call(user: unconfirmed_user, controller: @controller).success?
      unconfirmed_user.reload

      assert_not_nil unconfirmed_user.confirmation_sent_at
    end
  end
end
