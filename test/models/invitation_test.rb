require "test_helper"

describe Invitation do
  let(:invitation) { Invitation.new }

  it "must be valid" do
    value(invitation).must_be :valid?
  end
end
