require "test_helper"

describe Slack::FetchIdentity, :model do

  subject { Slack::FetchIdentity }

  context "valid" do

    it "returns slack_identity" do
      Slack::Web::Client.any_instance.expects(:users_identity)
                                     .returns(Slack::Identity::New.new)

      result = subject.call(token: "valid")
      assert result.success?
      assert_equal "maria@balvin.com", result.slack_identity.user.email
    end
  end


  context "invalid" do

    it "fails" do
      Slack::Web::Client.any_instance.expects(:users_identity)
                                     .returns(Slack::Identity::Invalid.new)

      refute subject.call(token: "invalid").success?
    end
  end
end