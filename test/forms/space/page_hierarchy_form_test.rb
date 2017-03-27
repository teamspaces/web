require "test_helper"

describe Space::PageHierarchyForm, :model do
  let(:space) { spaces(:spaces) }
  let(:root_page) { pages(:lowest_sort_order) }
  let(:main_page) { pages(:spaces) }
  let(:onboarding_page) { pages(:onboarding) }
  let(:marketing_page) { pages(:marketing) }
  subject { Space::PageHierarchyForm }

  let(:valid_page_hierarchy) do
    [{id: root_page.id},
     {id: main_page.id},
     {id: onboarding_page.id,
      children: [{id: marketing_page.id}]}]
  end

  describe "validates page hierarchy" do
    context "all space pages are included in hierarchy" do
      it "is valid" do
        assert subject.new(space: space, page_hierarchy: valid_page_hierarchy).valid?
      end
    end

    context "space pages are missing in hierarchy" do
      it "is not valid" do
        incomplete_hierarchy = [{id: onboarding_page.id,
                                 children: [{id: marketing_page.id}]}]

        refute subject.new(space: space, page_hierarchy: incomplete_hierarchy).valid?
      end
    end

    context "page_hierarchy includes external page" do
      it "is not valid" do
        hierarchy_with_external_page = [{id: main_page.id},
                                        {id: onboarding_page.id,
                                         children: [{id: marketing_page.id}]},
                                        {id: pages(:power_rangers).id}]

        refute subject.new(space: space, page_hierarchy: hierarchy_with_external_page).valid?
      end
    end
  end

  describe "#save" do
    it "works" do
      UpdatePageHierarchy.expects(:call)
                         .with(page_hierarchy: valid_page_hierarchy)

      subject.new(space: space, page_hierarchy: valid_page_hierarchy).save
    end
  end
end
