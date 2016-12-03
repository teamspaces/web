require "test_helper"

describe SlackProfile do
  let(:slack_profile) { SlackProfile.new }

  it "must be valid" do
    value(slack_profile).must_be :valid?
  end
end
