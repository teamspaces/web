require "test_helper"

describe Page::PathToRedirectToAfterDeletionInteractor, :controller do
  subject { Page::PathToRedirectToAfterDeletionInteractor }

  let(:controller) { get root_url(subdomain: ENV["DEFAULT_SUBDOMAIN"]); @controller }
  let(:page_to_delete) { pages(:onboarding) }
  let(:page_to_redirect) { pages(:marketing) }
  let(:space_page) { pages(:lowest_sort_order) }
  let(:only_page_in_space) { pages(:private_slack_user_milad) }

  describe "#call" do
    context "page_to_redirect_to provided" do
      context "page_to_redirect_to is not same as page_to_delete" do
        it "redirects to edit page_to_redirect_to" do
          redirect_path = subject.call(page_to_delete: page_to_delete,
                                       page_to_redirect: page_to_redirect,
                                       controller: controller).path

          assert_equal controller.edit_page_path(page_to_redirect), redirect_path
        end
      end

      context "page_to_redirect_to is same as page_to_delete" do
        it "does not redirect to page_to_redirect_to" do
          redirect_path = subject.call(controller: controller,
                                       page_to_delete: page_to_redirect,
                                       page_to_redirect: page_to_redirect).path

          assert_not_equal controller.edit_page_path(page_to_redirect), redirect_path
        end
      end
    end

    context "no page_to_redirect_to provided" do
      context "several other pages exist in space" do
        it "redirects to next_page" do
          subject.any_instance
                 .stubs(:next_page)
                 .returns(space_page)

          redirect_path = subject.call(page_to_delete: page_to_redirect,
                                       controller: controller).path

          assert_equal controller.edit_page_path(space_page), redirect_path
        end
      end

      context "page_to_delete is only page in space" do
        it "redirects to space_pages_path" do
          redirect_path = subject.call(page_to_delete: only_page_in_space,
                                       controller: controller).path

          assert_equal controller.space_pages_path(only_page_in_space.space), redirect_path
        end
      end
    end
  end
end
