require "test_helper"

describe Slack::Api::ExceptionHandler, :model do
  subject { Slack::Api::ExceptionHandler }

  describe "#new" do
    context "invalid authentication token provided" do
      let(:invalid_token_exception) { Slack::Web::Api::Error.new("invalid_auth") }
      let(:team_authentication) { team_authentications(:furrow_slack_authorization) }

      it "deletes authentication" do
        authentication = team_authentication

        subject.new(invalid_token_exception, authentication)

        assert authentication.destroyed?
      end
    end
  end
end
