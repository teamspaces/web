require "test_helper"

describe User::AcceptInvitationPolicy, :model do
  let(:subject) { User::AcceptInvitationPolicy }

  describe "#matching?" do
    describe "slack invitation" do
      let(:slack_invitation) { invitations(:slack_user_milad_invitation) }

      describe "slack user" do
        let(:matching_slack_user) { users(:slack_user_milad) }
        let(:non_matching_slack_user) { users(:slack_user_emil) }

        context "matching" do
          it "allows" do
            assert subject.new(matching_slack_user, slack_invitation).matching?
          end
        end

        context "non matching" do
          it "refutes" do
            refute subject.new(non_matching_slack_user, slack_invitation).matching?
          end
        end
      end

      describe "email user" do
        let(:email_user) { users(:without_team) }

        it "refutes" do
          refute subject.new(email_user, slack_invitation).matching?
        end
      end
    end

    describe "email invitation" do
      let(:email_invitation) { invitations(:katharina_at_power_rangers) }

      describe "email user" do
        let(:invited_email_user) { users(:without_team) }
        let(:not_invited_user) { users(:with_several_teams) }

        context "matching" do
          it "allows" do
            assert subject.new(invited_email_user, email_invitation).matching?
          end
        end

        context "non matching" do
          it "refutes" do
            refute subject.new(not_invited_user, email_invitation).matching?
          end
        end
      end

      describe "slack user" do
        let(:invited_slack_user) { users(:slack_user_milad) }

        context "matching email" do
          it "allows" do
            invited_slack_user.email = email_invitation.email
            assert subject.new(invited_slack_user, email_invitation).matching?
          end
        end
      end
    end
  end
end
