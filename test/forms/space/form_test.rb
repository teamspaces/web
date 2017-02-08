require "test_helper"

describe Space::Form, :model do
  let(:space) { spaces(:spaces) }

  subject { Space::Form.new(space: space) }

  describe "validations" do
    should validate_presence_of(:name)
    should validate_presence_of(:team)

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
      assert Space::Form.new(space: space, attributes: { name: "new_name" }).save

      assert_equal "new_name", space.name
    end
  end
end

