require "test_helper"

describe Space::MembersController do
  let(:user) { users(:lars) }
  let(:user2) { users(:ulf) }
  let(:team) { teams(:spaces) }
  let(:space) { spaces(:private) }
  before(:each) { sign_in user }

  describe "#index" do
    it "works" do
      get space_members_url(space, subdomain: team.subdomain)

      assert_response :success
    end
  end

  describe "#create" do
    it "adds a member to the space" do
      assert_difference -> { space.space_members.count }, 1 do
        post space_members_url(space, subdomain: team.subdomain), params: { space_member: { user_id: user2.id } }
      end
    end
  end

  describe "#destroy" do
    it "removes a member from the space" do
      assert_difference -> { space.space_members.count }, -1 do
        delete space_member_url(space, user, subdomain: team.subdomain)
      end
    end
  end
end
