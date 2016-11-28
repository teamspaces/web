require "test_helper"
require "slack_identites"

describe Slack::FetchIdentity, :model do
  include SlackIdentities

  subject { Slack::FetchIdentity }

  context "valid" do

    it "returns slack_identity" do
      Slack::Web::Client.any_instance.expects(:users_identity)
                                     .returns(valid_slack_identity)

      result = subject.call(token: "valid")
      assert result.success?
      assert_equal "emmanuel@furrow.io", result.slack_identity.user.email
    end
  end


  context "invalid" do

    it "fails" do
      Slack::Web::Client.any_instance.expects(:users_identity)
                                     .returns(invalid_slack_identity)

      refute subject.call(token: "invalid").success?
    end
  end
end
