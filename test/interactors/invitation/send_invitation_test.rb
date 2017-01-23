require "test_helper"

describe Invitation::SendInvitation, :model do
  subject { Invitation::SendInvitation }
  let(:user) { users(:lars) }

  describe "#call" do
    context "email invitation" do
      let(:email_invitation) { invitations(:katharina_at_power_rangers)}

      it "sends invitation as email" do
        SendEmailInvitationJob.expects(:perform_later).with(email_invitation.id, user.id)

        subject.call(invitation: email_invitation, user: user)
      end
    end

    context "slack invitation" do
      let(:slack_invitation) { invitations(:slack_user_milad_invitation) }

      it "sends invitation as email" do
        SendEmailInvitationJob.expects(:perform_later).with(slack_invitation.id, user.id)

        subject.call(invitation: slack_invitation, user: user)
      end

      it "sends invitation as slack message" do
        SendSlackInvitationJob.expects(:perform_later).with(slack_invitation.id, user.id)

        subject.call(invitation: slack_invitation, user: user)
      end
    end
  end
end
