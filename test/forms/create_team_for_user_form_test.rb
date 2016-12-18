require "test_helper"

describe CreateTeamForUserForm, :model do
  let(:team_name) { "nasa" }
  let(:team_subdomain) { "worldwide"}
  let(:user) { users(:lars) }
  let(:existing_team) { teams(:spaces) }

  subject do
   CreateTeamForUserForm.new(name: team_name, user: user,
                             subdomain: team_subdomain)
  end

  describe "validations" do
    should validate_presence_of(:user)
    should validate_presence_of(:name)
    should validate_presence_of(:subdomain)

    it "subdomain uniqueness" do
      subject.subdomain = existing_team.subdomain
      subject.save
      assert_includes subject.errors[:subdomain], "has already been taken"
    end

    it "subdomain format" do
      subject.subdomain = "team/nasa"
      refute subject.save
      assert subject.errors[:subdomain]
    end
  end

  it "creates team" do
    subject.save

    assert team_name, subject.team.name
    assert team_subdomain, subject.team.subdomain
  end

  it "creates first team member" do
    CreateTeamMemberForNewTeam.expects(:call)

    subject.save
  end
end
