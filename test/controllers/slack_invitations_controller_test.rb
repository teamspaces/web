require 'test_helper'

describe SlackInvitationsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }

  before(:each) { sign_in user }

  describe "#create" do
    let(:subject_url) { create_slack_invitation_url(subdomain: team.subdomain) }

    context "valid" do
      let(:valid_params) { { slack_user_id: "U908w", email: "gallen@nl.se" } }

       it "creates a slack invitation" do
        assert_difference -> { Invitation.count }, 1 do
          get subject_url, params: valid_params
        end
      end

      it "sends invitation" do
        SendInvitation.expects(:call).once

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
