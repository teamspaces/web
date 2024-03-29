require 'test_helper'

describe SlackInvitationsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }

  before(:each) do
    sign_in user
    Invitation::SlackInvitation::Send.stubs(:call).returns(true)
  end

  describe "#create" do
    let(:subject_url) { create_slack_invitation_url(subdomain: team.subdomain) }

    context "valid" do
      let(:valid_params) { { invited_slack_user_uid: "U908w", email: "gallen@nl.se" } }

       it "creates a slack invitation" do
        assert_difference -> { Invitation.count }, 1 do
          get subject_url, params: valid_params
        end
      end

      it "sends invitation, as email and slack message" do
        SendSlackInvitationJob.expects(:perform_later).once
        SendEmailInvitationJob.expects(:perform_later).once

        get subject_url, params: valid_params
      end

      it "redirects and shows success notice" do
        get subject_url, params: valid_params

        assert_equal I18n.t("invitation.slack.successfully_sent"), flash[:notice]
        assert_redirected_to invitations_url
      end
    end
  end
end
