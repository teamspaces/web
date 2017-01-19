require "test_helper"

describe Team::CreateTeamForUserForm, :model do
  let(:team_name) { "nasa" }
  let(:team_subdomain) { "worldwide"}
  let(:user) { users(:lars) }
  let(:existing_team) { teams(:spaces) }

  before(:each) do
    Team::Logo::AttachGeneratedLogo.stubs(:call).returns(true)
    Team::Logo::AttachUploadedLogo.stubs(:call).returns(true)
  end

  subject do
    Team::CreateTeamForUserForm.new(name: team_name, user: user,
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

  describe "save" do
    it "creates team" do
      subject.save

      assert team_name, subject.team.name
      assert team_subdomain, subject.team.subdomain
    end

    it "creates first team member" do
      CreateTeamMemberForNewTeam.expects(:call)

      subject.save
    end

    describe "team logo" do
      context "logo was uploaded" do
        let(:uploaded_logo_file) { "uploaded_logo_file" }

        it "attaches uploaded logo" do
          Team::Logo::AttachUploadedLogo.expects(:call)
                                        .with(has_entry(:file, uploaded_logo_file))
                                        .returns(true)

          subject.logo = uploaded_logo_file
        end
      end

      context "no logo was uploaded" do
        it "attaches generated logo" do
          Team::Logo::AttachGeneratedLogo.expects(:call)
                                         .returns(true)

          subject.save
        end
      end
    end
  end
end
