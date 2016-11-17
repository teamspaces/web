require "test_helper"

describe CreateTeamForUserForm, :model do
  let(:user) { users(:lars) }
  let(:existing_team) { teams(:furrow) }
  subject { CreateTeamForUserForm.new(name: "team_name", user: user) }

  describe "validations" do
    should validate_presence_of(:user)
    should validate_presence_of(:name)

    it "validates uniqueness of name" do
      subject.name = existing_team.name
      subject.save
      assert_includes subject.errors[:name], "name already in use"
    end
  end

  it "creates first team member" do
    CreateTeamMemberForNewTeam.expects(:call)

    subject.save
  end
end
