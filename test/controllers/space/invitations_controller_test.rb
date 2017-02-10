require "test_helper"

describe Space::InvitationsController do
  let(:invitation) { invitations(:jonas_at_spaces) }

  describe "#destroy" do
    it "destoryes invitation" do
      assert_difference -> { Invitation.count }, -1 do
        delete space_invitation_url(invitation, subdomain: team.subdomain)
      end
    end
  end
end
