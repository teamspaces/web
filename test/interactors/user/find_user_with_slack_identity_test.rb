require "test_helper"

describe User::FindUserWithSlackIdentity do

  subject { User::FindUserWithSlackIdentity }

  context "existent" do

    it "returns user" do
      result = subject.call(slack_identity: Slack::Identity::Existing.new)

      assert result.success?
      assert_kind_of User, result.user
    end
  end

  context "non existent" do

    it "fails" do
      refute subject.call(slack_identity: Slack::Identity::New.new).success?
    end
  end
end