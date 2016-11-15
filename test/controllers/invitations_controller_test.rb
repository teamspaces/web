require 'test_helper'

describe InvitationsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:furrow) }

  before(:each) { sign_in user }

  describe "#index" do
    it "renders the :index view" do
       get team_invitations_path(team)
       assert_response :success
    end
  end

  describe "#create" do
    it "creates an invitation" do
      assert_difference -> { Invitation.count }, 1 do
        params = { invitation: { email: "gallen@nl.se"} }
        post team_invitations_path(team), params: params
      end
    end

    it "has current_user as creator" do
      params = { invitation: { email: "gall@nl.se"} }
      post team_invitations_path(team), params: params

      invitation =  Invitation.find_by_email("gall@nl.se")
      assert_equal team, invitation.team
      assert_equal user, invitation.user
    end

    context "with invalid attributes" do

      it "does not create the invitation" do
        assert_difference -> { Invitation.count }, 0 do
          params = { invitation: { email: "invalid_email"} }
          post team_invitations_path(team), params: params
        end
      end
    end
  end

  describe "#destroy" do
    it "delets invitation" do
      assert_difference -> { Invitation.count }, -1 do
        delete invitation_path(invitations(:furrow))
      end
    end
  end
end
