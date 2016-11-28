require 'test_helper'

describe Invitations::AcceptController do
  let(:invitation) { invitations(:jonas_at_furrow) }

  describe "#show" do
    it "renders the :show view" do
       get accept_invitation_path(token: invitation.token)
       assert_response :success
    end
  end
end
