require "test_helper"

describe Page do
  let(:page) { Page.new }
  let(:space) { spaces(:furrow) }

  it "must be valid" do
    page.space = space
    assert_equal true, page.valid?
  end
end
