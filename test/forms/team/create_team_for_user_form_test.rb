require "test_helper"

describe Team::CreateTeamForUserForm, :model do
  let(:user) { users(:lars) }
  let(:team_params) { { name: "netherlands", subdomain: "netherlands"} }
  subject { Team::CreateTeamForUserForm.new(user: user, team_params: team_params) }
  before(:each) { Team::Logo::AttachGeneratedLogo.stubs(:call).returns(true) }

  describe "#save" do
    it "creates a team" do
      assert_difference -> { Team.count }, 1 do
        assert subject.save
      end
    end

    it "creates a team member" do
      assert_difference -> { TeamMember.count }, 1 do
        assert subject.save
      end
    end
  end
end
