require "test_helper"

describe Space::Form, :model do
  let(:user) { users(:lars) }
  let(:space) { spaces(:spaces) }

  subject { Space::Form.new(space: space) }

  describe "validations" do
    should validate_presence_of(:name)
    should validate_presence_of(:team_id)
    should validate_presence_of(:access_control)
    should validate_inclusion_of(:access_control).in_array([Space::AccessControl::TEAM, Space::AccessControl::PRIVATE])

    it "validates attached cover" do
      Shrine::Attacher.any_instance
                      .stubs(:errors)
                      .returns(ActiveModel::Errors.new(subject).tap { |errors| errors.add(:cover, :invalid) })

      refute subject.save
      assert subject.errors[:cover].present?
    end
  end

  describe "space cover" do
    let(:uploaded_cover_file) { "uploaded_cover_file" }

    it "attaches uploaded cover" do
      Space::Cover::AttachUploadedCover.expects(:call)
                                       .with(space: space, file: uploaded_cover_file)
                                       .returns(true)

      subject.cover = uploaded_cover_file
    end
  end

  describe "#save" do
    it "saves space" do
      assert Space::Form.new(space: space, user: user, attributes: { name: "new_name",  private_access_control: true }).save

      assert_equal "new_name", space.name
    end
  end
end

