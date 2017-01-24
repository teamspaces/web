require 'test_helper'

describe InvitationsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
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
        params = { send_invitation_form: { email: "gallen@nl.se"} }
        post team_invitations_url, params: params
      end
    end

    context "with invalid attributes" do

      it "does not create the invitation" do
        assert_difference -> { Invitation.count }, 0 do
          params = { send_invitation_form: { email: "invalid_email"} }
          post team_invitations_url, params: params
        end
      end
    end
  end

  describe "#destroy" do
    it "delets invitation" do
      assert_difference -> { Invitation.count }, -1 do
        delete invitation_url(invitations(:jonas_at_spaces), subdomain: team.subdomain)
      end
    end
  end
end
