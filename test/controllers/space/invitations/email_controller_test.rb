require "test_helper"

describe Space::Invitations::EmailController do
  let(:user) { users(:ulf) }
  let(:team) { user.teams.first }
  let(:space) { team.spaces.first }
  before(:each) { sign_in user }

  describe "#new" do
    it "works" do
      get new_space_invitations_email_url(space, subdomain: team.subdomain)

      assert_response :success
    end
  end

  describe "#create" do
    it "creates a space invitation" do
      assert_difference -> { space.invitations.count }, 1 do
        params = { invitation: { email: "gallen@nl.se"} }
        post space_invitations_email_path(space, subdomain: team.subdomain), params: params

        assert_redirected_to space_members_path(space)
      end
    end
  end
end
