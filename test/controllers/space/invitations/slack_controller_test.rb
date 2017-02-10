require "test_helper"

describe Space::Invitations::SlackController do
  let(:user) { users(:lars) }
  let(:space) { spaces(:spaces) }
  let(:team) { teams(:spaces) }

  before(:each) do
    sign_in user
    Team::FindInvitableSlackUsers.any_instance.stubs(:all).returns([])
    Invitation::SlackInvitation::Send.stubs(:call).returns(true)
  end

  describe "#new" do
    it "works" do
      get new_space_invitations_slack_url(space, subdomain: team.subdomain)

      assert_response :success
    end
  end

  describe "#create" do
    it "creates a space slack invitation" do
      params = { invited_slack_user_uid: "U908w", email: "gallen@nl.se" }

      assert_difference -> { space.invitations.count }, 1 do
        get space_invitations_slack_url(space, subdomain: team.subdomain), params: params
      end

      assert_redirected_to space_members_path(space)
    end
  end
end
