require "test_helper"

describe InvitationDecorator, :model do

  let(:email_invitation) { invitations(:katharina_at_power_rangers).decorate }
  let(:slack_invitation) { invitations(:slack_user_milad_invitation).decorate }
  let(:accepted_invitation) { invitations(:accepted_invitation).decorate }

  describe "#email_invitation?" do
    context "email_invitation" do
      it { assert email_invitation.email_invitation? }
    end

    context "slack_invitation" do
      it { refute slack_invitation.email_invitation? }
    end
  end

  describe "#slack_invitation?" do
    context "slack_invitation" do
      it { assert slack_invitation.slack_invitation? }
    end

    context "email_invitation" do
      it { refute email_invitation.slack_invitation? }
    end
  end

  describe "#invitee_email_kown?" do
    context "email_invitation" do
      it { assert email_invitation.invitee_email_kown? }
    end

    context "slack_invitation" do
      it { assert slack_invitation.invitee_email_kown? }
    end
  end

  describe "#already_accepted?" do
    context "accepted_invitation" do
      it { assert accepted_invitation.already_accepted? }
    end

    context "open_invitation" do
      it { refute email_invitation.already_accepted? }
    end
  end

  describe "#invitee_is_registered_email_user?" do
    context "invitee already registered with email" do
      it { assert email_invitation.invitee_is_registered_email_user? }
    end

    context "invitee is not registered with email" do
      it { refute slack_invitation.invitee_is_registered_email_user? }
    end
  end
end
