require "test_helper"

describe Invitation::SendInvitation, :model do

  subject { Invitation::SendInvitation }

  describe "#call" do
    context "email invitation" do
      let(:email_invitation) { invitations(:katharina_at_power_rangers)}

      it "sends invitation as email" do
        SendEmailInvitationJob.expects(:perform_later).with(email_invitation.id)

        subject.call(invitation: email_invitation)
      end
    end

    context "slack invitation" do
      let(:slack_invitation) { invitations(:slack_user_milad_invitation) }

      it "sends invitation as email" do
        SendEmailInvitationJob.expects(:perform_later).with(slack_invitation.id)

        subject.call(invitation: slack_invitation)
      end

      it "sends invitation as slack message" do
        SendSlackInvitationJob.expects(:perform_later).with(slack_invitation.id)

        subject.call(invitation: slack_invitation)
      end
    end
  end
end
