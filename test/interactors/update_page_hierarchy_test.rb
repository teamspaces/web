require "test_helper"

describe UpdatePageHierarchy, :model do
  let(:main_page) { pages(:spaces) }
  let(:onboarding_page) { pages(:onboarding) }
  let(:marketing_page) { pages(:marketing) }

  let(:page_hierarchy) do
    [{id: main_page.id},
     {id: onboarding_page.id,
      children: [{id: marketing_page.id}]}]
  end

  describe "#call" do
    it "updates page hierarchy" do
      assert UpdatePageHierarchy.call(page_hierarchy: page_hierarchy).success?

      assert_includes main_page.siblings, onboarding_page
      assert_includes onboarding_page.children, marketing_page
    end
  end
end
