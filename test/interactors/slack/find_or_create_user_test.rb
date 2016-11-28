require "test_helper"

describe Slack::FindOrCreateUser, :model do

  subject { Slack::FindOrCreateUser }

  describe "#call" do
    context "existent" do

      it "finds user" do
        result = subject.call(slack_identity: Slack::Identity::Existing.new, token: "secret")

        assert result.success?
        assert_kind_of User, result.user
      end
    end

    context "non existent" do

      it "creates user" do
        result = subject.call(slack_identity: Slack::Identity::New.new, token: "secret")

        assert result.success?
        assert_kind_of User, result.user
      end
    end
  end

  describe "#rollback" do
    context "user was created" do
      it "rollbacks creation" do
        Slack::CreateUser.expects(:call).returns(context_mock = mock)
        context_mock.stubs(:success?).returns(true)
        context_mock.stubs(:user).returns(users(:lars))
        context_mock.expects(:rollback!)

        result = subject.call(slack_identity: Slack::Identity::New.new, token: "secret")

        result.rollback!
      end
    end
  end
end
