require "test_helper"

describe User::Email::SendConfirmationInstructions, :controller do
  subject { User::Email::SendConfirmationInstructions }
  let(:unconfirmed_user) { users(:with_unconfirmed_email) }
  let(:mailer_mock) do
    mailer_mock = mock()
    mailer_mock.stubs(:deliver_later).returns(true)
    mailer_mock
  end
  before(:each) { sign_in unconfirmed_user }

  describe "#call" do
    describe "current_url can be used as email link for confirmation" do
      it "sends confirmation mail, with link to current url" do
        CustomDeviseMailer.expects(:confirmation_instructions)
                          .with(unconfirmed_user, unconfirmed_user.confirmation_token,
                                {confirmation_url: team_url(subdomain: unconfirmed_user.teams.first.subdomain, confirmation_token: unconfirmed_user.confirmation_token) })
                          .returns(mailer_mock)

        get team_url(subdomain: unconfirmed_user.teams.first.subdomain)
      end
    end

    describe "current_url can't be used as email link for confirmation" do
      it "sends confirmation mail, with link to subdomain root url" do
        CustomDeviseMailer.expects(:confirmation_instructions)
                          .with(unconfirmed_user, unconfirmed_user.confirmation_token,
                                {confirmation_url: root_subdomain_url(subdomain: unconfirmed_user.teams.first.subdomain, confirmation_token: unconfirmed_user.confirmation_token)})
                          .returns(mailer_mock)

        post user_email_confirmation_url(subdomain: unconfirmed_user.teams.first.subdomain)
      end
    end

    it "saves email sent at time" do
      get team_url(subdomain: unconfirmed_user.teams.first.subdomain)

      assert subject.call(user: unconfirmed_user, controller: @controller).success?
      unconfirmed_user.reload

      assert_not_nil unconfirmed_user.confirmation_sent_at
    end
  end
end
