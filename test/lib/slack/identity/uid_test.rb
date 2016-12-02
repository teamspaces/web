require "test_helper"

describe Slack::Identity::UID do
  subject { Slack::Identity::UID }

  describe "#build" do
    it "builds uid" do
      uid = subject.build(TestHelpers::Slack.identity(:existing_user))

      assert_equal "U2ZKLGE49-T0C7MBADQ", uid
    end
  end

  describe "#parse" do
    it "parses uid" do
      info = subject.parse("U2ZKLGE49-T0C7MBADQ")

      assert_equal "U2ZKLGE49", info[:user_id]
      assert_equal "T0C7MBADQ", info[:team_id]
    end
  end
end
