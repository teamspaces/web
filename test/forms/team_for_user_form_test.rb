require "test_helper"

describe TeamForUserForm, :model do
  let(:user) { users(:lars) }
  let(:existing_team) { teams(:furrow) }
  subject { TeamForUserForm.new(name: "team_name", user: user) }

  describe "validations" do
    should validate_presence_of(:user)
    should validate_presence_of(:name)

    it "validates url safe name" do
      subject.name = "not/save"
      subject.save
      assert_includes subject.errors[:name], "has special characters"
    end

    it "validates uniqueness of name" do
      subject.name = existing_team.name
      subject.save
      assert_includes subject.errors[:name], "name already in use"
    end
  end

  it "creates first team member" do
    CreateTeamMemberForNewTeam.expects(:call)

    TeamForUserForm.new(name: "team_name", user: user).save
  end
end
