require 'test_helper'

describe InvitationsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:invitation) { invitations(:jonas_at_spaces) }
  let(:team_invitations_url) { invitations_url(subdomain: team.subdomain) }

  before(:each) do
    Team::FindInvitableSlackUsers.any_instance.stubs(:all).returns([])
    sign_in user
  end

  describe "#index" do
    it "renders the :index view" do
      get team_invitations_url
      assert_response :success
    end
  end

  describe "#create" do
    it "creates an invitation" do
      assert_difference -> { Invitation.count }, 1 do
        post team_invitations_url, params: { invitation: { email: "gallen@nl.se"} }
      end
    end

    context "with invalid attributes" do
      it "does not create the invitation" do
        assert_difference -> { Invitation.count }, 0 do
          post team_invitations_url, params: { invitation: { email: "invalid_email"} }
        end
      end
    end
  end

  describe "#destroy" do
    it "delets invitation" do
      assert_difference -> { Invitation.count }, -1 do
        delete invitation_url(invitation, subdomain: team.subdomain)
      end
    end
  end

  describe "#resend" do
    it "sends invitation" do
      Invitation::SendInvitation.expects(:call).with(invitation: invitation)

      get send_invitation_url(invitation, subdomain: team.subdomain)

      assert_redirected_to invitations_url(subdomain: team.subdomain)
    end
  end
end
