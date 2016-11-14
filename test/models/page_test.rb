require "test_helper"

describe Page do
  let(:page) { Page.new }
  let(:space) { spaces(:furrow) }

  context "#contents" do
    it "returns the body of the latest published page_revision" do
      skip
    end
  end

  it "must be valid" do
    page.space = space
    assert_equal true, page.valid?
  end
end
