require "test_helper"

describe User::AcceptInvitationPath, :controller do

  subject { User::AcceptInvitationPath }
  let(:invitation) { invitations(:slack_user_milad_invitation) }
  let(:invited_user) { users(:slack_user_milad) }
  let(:not_invited_user) { users(:ulf) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:invitation_cookie_mock) { InvitationCookieMock.new(invitation) }
  before(:each) do
    User::SignInPath.any_instance.stubs(:call); User::SignInPath.any_instance.stubs(:path)
    LoginRegisterFunnel::InvitationCookie.stubs(:new).returns(invitation_cookie_mock)
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

    it "returns invitation team sign in path" do
      subject.any_instance.expects(:user_sign_in_path)
                          .with(team_to_redirect_to: invitation.team).returns(true)

      subject.call(user: invited_user, controller: controller)
    end
  end

  describe "user is not invited" do
    it "does not accept invitation" do
      User::AcceptInvitation.expects(:call).never

      subject.call(user: not_invited_user, controller: controller)
    end

    it "returns user sign in path" do
      subject.any_instance.expects(:user_sign_in_path).with(nil)

      subject.call(user: not_invited_user, controller: controller)
    end
  end
end
