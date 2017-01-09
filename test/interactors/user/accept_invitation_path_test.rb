require "test_helper"

describe User::AcceptInvitationPath, :controller do

  subject { User::AcceptInvitationPath }
  let(:invitation) { invitations(:slack_user_milad_invitation) }
  let(:invited_user) { users(:slack_user_milad) }
  let(:not_invited_user) { users(:ulf) }
  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  before(:each) { User::SignInPath.any_instance.stubs(:call); User::SignInPath.any_instance.stubs(:path) }

  def mock_invitation_cookie_with(invitation)
    invitation_cookie_mock = InvitationCookieMock.new(invitation)
    LoginRegisterFunnel::InvitationCookie.stubs(:new).returns(invitation_cookie_mock)
    invitation_cookie_mock
  end

  it "deletes invitation cookie" do
    invitation_cookie_mock = mock_invitation_cookie_with(invitation)
    invitation_cookie_mock.expects(:delete)

    subject.call(user: invited_user, controller: controller)
  end

  describe "user is invited" do
    it "user gets added to host team" do
      mock_invitation_cookie_with(invitation)
      subject.call(user: invited_user, controller: controller)

      assert_includes invited_user.teams, invitation.team
    end

    it "returns invitation team sign in path" do
      mock_invitation_cookie_with(invitation)
      subject.any_instance.expects(:user_sign_in_path)
                          .with(team_to_redirect_to: invitation.team).returns(true)

      subject.call(user: invited_user, controller: controller)
    end
  end

  describe "user is not invited" do
    it "user does not get added to host team" do
      mock_invitation_cookie_with(invitation)
      subject.call(user: invited_user, controller: controller)

      refute_includes not_invited_user.teams, invitation.team
    end

    it "returns user sign in path" do
      mock_invitation_cookie_with(invitation)
      subject.any_instance.expects(:user_sign_in_path).with(nil)

      subject.call(user: not_invited_user, controller: controller)
    end
  end
end
