require "test_helper"

describe Space::InvitationsController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:space) { spaces(:spaces) }
  let(:invitation) { invitations(:jonas_at_spaces) }
  before(:each) { sign_in user }

  describe "#destroy" do
    it "destoryes invitation" do
      assert_difference -> { Invitation.count }, -1 do
        delete space_invitation_url(space, invitation, subdomain: team.subdomain)

        assert_redirected_to space_members_path(space)
      end
    end
  end
end
