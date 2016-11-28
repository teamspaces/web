require "test_helper"
require "slack_identites"

describe Slack::FindUser do
  include SlackIdentities

  subject { Slack::FindUser }

  context "existent" do

    it "returns user" do
      result = subject.call(slack_identity: existing_slack_identity)

      assert result.success?
      assert_kind_of User, result.user
    end
  end

  context "non existent" do

    it "fails" do
      refute subject.call(slack_identity: new_slack_identity).success?
    end
  end
end
