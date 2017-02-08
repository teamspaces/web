require "test_helper"

describe Invitation::Slack::Send, :model do
  include Rails.application.routes.url_helpers

  subject { Invitation::Slack::Send }
  let(:invitation) { invitations(:slack_user_milad_invitation) }

  it "sends invitation as slack message with link to accept_invitation path" do
    subject.any_instance.stubs(:client).returns(client_mock = mock)
    client_mock.expects(:chat_postMessage).with do |message|
      message[:text].include? "Hi Milad, Lars invited you to collaborate on Spaces"
      message[:text].include? accept_invitation_path(invitation.token)
      message[:icon_url].include? "/assets/images/icons/space_ship.png"
    end

    result = subject.call(invitation: invitation)
    assert result.success?
  end
end
