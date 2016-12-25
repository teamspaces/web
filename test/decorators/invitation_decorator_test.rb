require "test_helper"

describe InvitationDecorator, :model do

  let(:email_invitation) { invitations(:katharina_at_power_rangers).decorate }
  let(:slack_invitation) { invitations(:slack_user_milad_invitation).decorate }
  let(:accepted_invitation) { invitations(:accepted_invitation).decorate }

  describe "#slack_invitation?" do
    context "slack_invitation" do
      it { assert slack_invitation.slack_invitation? }
    end

    context "email_invitation" do
      it { refute email_invitation.slack_invitation? }
    end
  end

  describe "#email_invitation?" do
    context "email_invitation" do
      it { assert email_invitation.email_invitation? }
    end

    context "slack_invitation" do
      it { refute slack_invitation.email_invitation? }
    end
  end

  describe "#already_accepted?" do
    context "accepted invitation" do
      it { assert accepted_invitation.already_accepted? }
    end

    context "open invitation" do
      it { refute email_invitation.already_accepted? }
    end
  end

  describe "#accepting_user_is_already_registered_using_email?" do
    context "accepting user is already registered using email" do
      it { assert email_invitation.accepting_user_is_already_registered_using_email? }
    end

    context "accepting user is not yet registered using email" do
      it { refute slack_invitation.accepting_user_is_already_registered_using_email? }
    end
  end
end
