require "test_helper"

describe RootSubdomainController do
  describe "#index" do
    context "no space" do
      it "redirects to new space" do
        get root_subdomain_url
        assert_redirected_to new_space_path
      end
    end

    context "with one space" do
      it "redirects to the pages of that space" do
        assert_redirected_to space_pages_path
      end
    end

    context "with several spaces" do
      it "redirects to choose space" do
        assert_redirected_to spaces_path
      end
    end
  end
end
