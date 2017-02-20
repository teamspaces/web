require "test_helper"

describe Space::AccessControlController do
  let(:user) { users(:lars) }
  let(:team) { teams(:spaces) }
  let(:space) { spaces(:private) }
  before(:each) { sign_in user }

  describe "#update" do
    it "works" do
      patch space_access_control_url(space, subdomain: team.subdomain,
                                            params: { space: { access_control: Space::AccessControl::TEAM }})

      assert_response :success
      assert space.reload.access_control.team?
    end
  end
end
