require "test_helper"

describe User::FindUserWithSlackIdentity, :model do

  subject { User::FindUserWithSlackIdentity }

  context "existent" do

    it "returns user" do
      slack_user = users(:slack_user_milad)

      result = subject.call(slack_identity: TestHelpers::Slack.identity(:existing_user))

      assert result.success?
      assert_kind_of User, result.user
    end
  end

  context "non existent" do

    it "fails" do
      refute subject.call(slack_identity: TestHelpers::Slack.identity(:unknown_user)).success?
    end
  end
end
