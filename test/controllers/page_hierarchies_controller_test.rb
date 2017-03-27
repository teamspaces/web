require "test_helper"

describe PageHierarchiesController do
  let(:team){ teams(:spaces) }
  let(:space){ spaces(:spaces) }
  before(:each){ sign_in users(:lars) }

  let(:valid_page_hierarchy) do
    [{id: pages(:lowest_sort_order).id},
     {id: pages(:spaces).id},
     {id: pages(:onboarding).id,
      children: [{id: pages(:marketing).id}]}]
  end

  describe "#update" do
    context "valid hierarchy" do
      it "works" do
        patch space_page_hierarchy_url(space, subdomain: team.subdomain, params: { page_hierarchy: valid_page_hierarchy })

        assert_response :ok
      end
    end

    context "invalid hierarchy" do
      it "works" do
        patch space_page_hierarchy_url(space, subdomain: team.subdomain, params: { page_hierarchy: [{id: pages(:spaces).id}] })

        assert_response :unprocessable_entity
      end
    end
  end
end
