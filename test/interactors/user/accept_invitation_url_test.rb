require "test_helper"

describe User::AcceptInvitationUrl, :controller do

  subject { User::AcceptInvitationUrl }
  let(:invitation) { invitations(:slack_user_milad_invitation) }
  let(:invited_user) { users(:slack_user_milad) }
  let(:not_invited_user) { users(:ulf) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:invitation_cookie_mock) { InvitationCookieMock.new(invitation) }
  before(:each) do
    User::SignInUrlDecider.any_instance.stubs(:call); User::SignInUrlDecider.any_instance.stubs(:url)
    LoginRegisterFunnel::BaseController::InvitationCookie.stubs(:new).returns(invitation_cookie_mock)
  end

  it "deletes invitation cookie" do
    invitation_cookie_mock.expects(:delete)

    subject.call(user: invited_user, controller: controller)
  end

  describe "user is invited" do
    it "accepts invitation" do
      User::AcceptInvitation.expects(:call).with(user: invited_user, invitation: invitation)

      subject.call(user: invited_user, controller: controller)
    end

    it "returns sign in url for invitation team" do
      url = subject.call(user: invited_user, controller: controller).url

      assert_equal User::SignInUrlDecider.call(user: invited_user,
                                               team_to_redirect_to: invitation.team,
                                               controller: controller).url, url
    end
  end

  describe "user is not invited" do
    it "does not accept invitation" do
      User::AcceptInvitation.expects(:call).never

      subject.call(user: not_invited_user, controller: controller)
    end

    it "returns user sign in url" do
      url = subject.call(user: not_invited_user, controller: controller).url

      assert_equal User::SignInUrlDecider.call(user: not_invited_user,
                                               controller: controller).url, url
    end
  end
end
