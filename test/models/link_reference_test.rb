require "test_helper"

describe LinkReference do
  let(:link_reference) { LinkReference.new }

  it "must be valid" do
    value(link_reference).must_be :valid?
  end
end
