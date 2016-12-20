require "test_helper"

describe Invitation::SendSlackInvitation, :model do
  subject { Invitation::SendSlackInvitation }
  let(:invitation) { invitations(:slack_user_milad_invitation) }

  it "sends invitation as slack message" do
    subject.any_instance.stubs(:client).returns(client_mock = mock)
    client_mock.expects(:chat_postMessage).with() do |message|
      message[:text].include? "Hi Milad, Lars invited you to collaborate on Spaces"
      message[:text].include? "/accept_invitation/#{invitation.token}"
    end

    result = subject.call(invitation: invitation)
    assert result.success?
  end
end
