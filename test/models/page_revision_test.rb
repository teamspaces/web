require "test_helper"

describe PageRevision do
  let(:page_revision) { PageRevision.new }

  it "must be valid" do
    value(page_revision).must_be :valid?
  end
end
