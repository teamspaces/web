require "test_helper"

describe Team::UpdateTeamForm, :model do
  let(:team) { teams(:spaces) }
  subject { Team::UpdateTeamForm.new(team) }
  before(:each) { Team::Logo::AttachUploadedLogo.stubs(:call).returns(true) }

  describe "save" do
    it "updates team" do
      subject.name = "My Team"
      subject.save

      assert "My Team", team.name
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
    end
  end
end
