require "test_helper"

describe CollabPage do
  let(:collab_page) { CollabPage.new }

  it "must be valid" do
    assert_equal true, collab_page.valid?
  end
end
