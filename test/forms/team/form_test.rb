require "test_helper"

describe Team::Form, :model do
  let(:existing_team) { teams(:spaces) }
  let(:generated_logo) { "generated_logo" }
  subject { Team::Form.new }

  before(:each) do
    Team::Logo::AttachGeneratedLogo.stubs(:call).returns(true)
    Team::Logo::AttachUploadedLogo.stubs(:call).returns(true)
  end

  describe "validations" do
    should validate_presence_of(:name)
    should validate_presence_of(:subdomain)

    it "validates subdomain uniqueness" do
      subject.subdomain = existing_team.subdomain
      subject.save
      assert_includes subject.errors[:subdomain], "has already been taken"
    end

    it "validates subdomain format" do
      subject.subdomain = "team/nasa"
      refute subject.save
      assert subject.errors[:subdomain]
    end
  end

  describe "#save" do
    context "new team" do
      it "creates a team" do
        assert_difference -> { Team.count }, 1 do
          Team::Form.new(params: { name: "airbnb", subdomain: "airbnb" }).save
        end
      end
    end

    context "existing_team" do
      it "updates the team" do
        Team::Form.new(team: existing_team, params: { name: "updated_name"}).save
        existing_team.reload

        assert_equal "updated_name", existing_team.name
      end
    end
  end

  describe "logo" do
    let(:uploaded_logo_file) { "uploaded_logo_file" }

    it "attaches uploaded logo" do
      Team::Logo::AttachUploadedLogo.expects(:call).with(has_entry(:file, uploaded_logo_file)).returns(true)

      subject.logo = uploaded_logo_file
    end

    context "no logo provided" do
      it "generates a team logo" do
        Team::Logo::AttachGeneratedLogo.expects(:call).returns(true)

        Team::Form.new(params: { name: "huelsta", subdomain: "huelsta" }).save
      end
    end

    describe "has generated logo" do
      before(:each) do
        existing_team.stubs(:logo).returns(generated_logo)
        Image.any_instance.stubs(:generated?).returns(true)
      end

      context "team name changes" do
        it "generates a new logo" do
          Team::Logo::AttachGeneratedLogo.expects(:call).returns(true)

          Team::Form.new(team: existing_team, params: { name: "new_name" }).save
        end
      end

      context "team name does not change" do
        it "does not generate a new logo" do
          Team::Logo::AttachGeneratedLogo.expects(:call).never

          Team::Form.new(team: existing_team, params: { name: existing_team.name }).save
        end
      end
    end
  end
end
