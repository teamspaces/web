require "test_helper"

describe Space::PageHierarchyForm, :model do
  let(:space) { spaces(:spaces) }
  let(:main_page) {pages(:spaces)}
  let(:onboarding_page) {pages(:onboarding)}
  let(:marketing_page) {pages(:marketing)}
  subject { Space::PageHierarchyForm }

  describe "validates page hierarchy" do
    context "all space pages are included in hierarchy" do
      it "is valid" do
        valid_page_hierarchy = [{id: main_page.id},
                                {id: onboarding_page.id, children: [
                                  {id: marketing_page.id}]}
                                ]
        assert subject.new(space: space,
                           page_hierarchy: valid_page_hierarchy)
                      .valid?
      end
    end

    context "space pages are duplicated in hierarchy" do
      it "is not valid" do

      end
    end

    context "space pages are missing in hierarchy" do
      it "is not valid" do

      end
    end
  end

  describe "#save" do

  end
end
